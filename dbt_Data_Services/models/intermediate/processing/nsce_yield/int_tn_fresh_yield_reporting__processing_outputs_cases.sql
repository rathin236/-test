with wms_pmintdtl_tbl as (
    select * from {{ ref('stg_coolearth__wms_pmintdtl_tbl') }}
),

wms_contcase_tbl as (
    select * from {{ ref('stg_coolearth__wms_contcase_tbl') }}
),

wms_contdtl_tbl as (
    select * from {{ ref('stg_coolearth__wms_contdtl_tbl') }}
),

im_item_attribute_values as (
    select * from {{ ref('item_attribute_values') }}
),

erpx_mf_site as (
    select * from {{ ref('stg_northscope__erpx_mf_site') }}
),

wm_production_line_def as (
    select * from {{ ref('stg_coolearth__wm_production_line_def') }}
),

erpx_im_itemset as (
    select * from {{ ref('stg_northscope__erpx_im_itemset') }}
),

erpx_im_itemset_items as (
    select * from {{ ref('stg_northscope__erpx_im_itemset_items') }}
),

wmproductiondetail as (
    select * from {{ ref('stg_coolearth__wmproductiondetail') }}
),

int_tn_fresh_yield_reporting__processing_outputs_cases as (

    select distinct

        pmd.gl_cmp_key as "Company",
        pmd.in_whs_key as "Facility",
        pmd.wms_conthdr_key as "PalletNumber",
        pmd.wms_contcase_key as "CaseNumber",
        cdtl.in_item_key::string as "ItemNumber",
        'CASE' as "PalletUoM",
        pmd.wms_contcase_ctwgt as "PalletVolume",
        pmd.wms_contcase_uom as "CaseUoM",
        pmd.wms_contcase_ctwgt as "CaseVolume",
        1 as "FWtoLBConversion",
        1 as "Units",
        'Output' as "TransactionType",
        'RW Cases' as "ItemProfile",
        pmd.dbserverdatetime as "dbDT",
        pmd.wms_contcase_prddt as "DateTime_Transaction",
        pmd.wms_contdtl_key as "Key_Contdtl",
        wmpd.salesorder as "Allocation",
        to_date(pmd.wms_contcase_prddt) as "Key_Date",
        case
            when pmd.wms_contcase_acwgt < 0
                then contc.pieces * -1
            else contc.pieces
        end as "Pieces",
        case
            when pmd.wms_contcase_uom = 'LB'	-- RW Case
                then pmd.wms_contcase_ctwgt
            when pmd.wms_contcase_uom = 'KG'	-- RW Case
                then (pmd.wms_contcase_ctwgt * 2.2046)
            else 0
        end as "Lbs",
        case
            when itsetitems.itemsk is null
                then 'InvalidOutputItem'
            else 'ValidOutputItem'
        end as "ItemSetCheck",
        to_date(pmd.wms_contcase_prddt) as "Date_Transaction",
        'NS_' || item.dataentitycompany_sk as "Key_Company",
        'NS_' || site.sitesk as "Key_Site",
        coalesce('NS_' || item.item_sk, 'IncorrectDivision') as "Key_Item",
        'CE_' || pmd.gl_cmp_key || '_' || iff(coalesce(contc.lot, 'MissingLot') = '', 'MissingLot', contc.lot) as "Key_Lot",
        'CE_' || trim(contc.linekey) as "Key_Line"

    from wms_pmintdtl_tbl as pmd  -- Coolearth table for case level details of production output

    /**********************************************************************************************
    wms_contcase table is the Coolearth table representing current/active case level details
    Fields being gathered from this table include Piece count, Lot number, and Line number
    Other fields are also used for join criteria in subsequent tables
    With respect to the final JOIN condition TNS is a company that transfers cases between divisions,
    when that happens case records are duplicated but the warehouse column is updated to show the new location
    This means that case #xyz123 can have two nearly identical records in the contcase table with no real way to differentiate them
    Therefore, we want to exclude the warehouses that exist in the same company but belong to a different division (AFS & AC Covert)
    One way to do this is to limit joined contcase results down to warehouses within the same division
        This is not perfect and is subject to change
    **********************************************************************************************/

    left join wms_contcase_tbl as contc
        on pmd.wms_contcase_prddt = contc.wms_contcase_prddt		  -- production date/time must match between pmintdtl and contcase
            and pmd.wms_contcase_key = contc.wms_contcase_key		  -- case number must match between pmintdtl and contcase
            and contc.gl_cmp_key = 'TNS'							  -- Isolates contcase records to just TNS company
            and contc.in_whs_key in ('FBD', 'MACH', 'HERM', 'BLKS')	  -- See table comment above

    /**********************************************************************************************
    wms_contdtl table is one of the Coolearth table representing current/active Pallet level details
    Item number is the only field being gathered from this table, but other fields are also used for subsequent joins
    This table also is bound by the previously mentioned inconveniences with the contcase table with respect to warehouses.
    **********************************************************************************************/

    left join wms_contdtl_tbl as cdtl
        on contc.wms_conthdr_key = cdtl.wms_conthdr_key					    -- Pallet number must match between contcase and contdtl
            and contc.wms_contdtl_key = cdtl.wms_contdtl_key			    -- contdtl_key must match between contcase and contdtl
            and contc.in_whs_key = cdtl.in_whs_key							-- warehouse must match between contcase and contdtl
            and cdtl.gl_cmp_key = 'TNS'									    -- Isolates contdtl records to just TNS company
            and cdtl.in_whs_key in ('FBD', 'MACH', 'HERM', 'BLKS')			-- See table comment from contcase comments

    /**********************************************************************************************
    The Item Attribute Values view is maintained by NorthScope and provides most attributes for all items
    This join allows us to tie into the DataEntityCompanySK key that NorthScope uses throughout their system,
    it also allows us to join into other tables such as the item set data in order to determine whether or not produced items are 'valid'
    **********************************************************************************************/

    left join im_item_attribute_values as item
        on cdtl.in_item_key = item.item_id	    -- Coolearth item number must match NorthScope item
            and item.dataentitycompany_sk = 1	-- DataEntityCompanySK = 1 means TNS, this prevents duplicates being returned from this join and is required
            and item."Division" = 'TNS'		    -- Similar to above, this eliminates duplicates that may have occurred from within the same company but another division

    /**********************************************************************************************
    This is the site table from NorthScope
    Nothing substantial here, it allows us to generate the Key_site value
    **********************************************************************************************/

    left join erpx_mf_site as site
        on pmd.in_whs_key = site.hostsystemlink
            and site.dataentitycompanysk = 1

    left join wm_production_line_def as prodl
        on contc.linekey = prodl.linekey
            and prodl.company = 'TNS'

    left join erpx_im_itemset as itemset
        on trim(substring(prodl.linedescription, charindex('- ', prodl.linedescription) + 1, len(prodl.linedescription))) = itemset.itemsetname
            and itemset.dataentitycompanysk = 1

    left join erpx_im_itemset_items as itsetitems
        on itemset.itemsetsk = itsetitems.itemsetsk
            and item.item_sk = itsetitems.itemsk

    /**********************************************************************************************
    Join for allocation details
    **********************************************************************************************/

    left join wmproductiondetail as wmpd
        on contc.gl_cmp_key = wmpd.company
            and contc.in_whs_key = wmpd.warehouse
            and substring(contc.allocation, 0, charindex('_', contc.allocation, 0) - 1) = wmpd.orderkey

    /*******************************************************************************************************************************************
    WHERE condition notes:
            The SSRS assets are limited to just the current and previous month.
            Also keep in mind that within the JOIN conditions into the Item Attribute Values
            we're limiting the results to only include TNS company & TNS division items. That explicitly excludes AFS and AC Covert divisions
    *******************************************************************************************************************************************/
    where pmd.gl_cmp_key = 'TNS'
        and pmd.in_whs_key in ('FBD', 'MACH', 'HERM', 'BLKS')

)

select * from int_tn_fresh_yield_reporting__processing_outputs_cases
where "Facility" = 'FBD'
/* For Testing */
-- where "CaseNumber" = '46554'
-- and "PalletNumber" = '11885734'
