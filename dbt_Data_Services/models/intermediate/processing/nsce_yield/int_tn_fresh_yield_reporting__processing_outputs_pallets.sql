with wms_pmint_tbl as (
    select * from {{ ref('stg_coolearth__wms_pmint_tbl') }}
),

wms_pmintdtl_tbl as (
    select * from {{ ref('stg_coolearth__wms_pmintdtl_tbl') }}
),

wms_contdtl_tbl as (
    select * from {{ ref('stg_coolearth__wms_contdtl_tbl') }}
),

im_item_attribute_values as (
    select * from {{ ref('item_attribute_values') }}
),

erpx_im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),

erpx_im_uom_schedule_conversion_value as (
    select * from {{ ref('stg_northscope__erpx_im_uom_schedule_conversion_value') }}
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

int_tn_fresh_yield_reporting__processing_outputs_pallets as (

    select

        pmint.gl_cmp_key as "Company",
        pmint.in_whs_key as "Facility",
        pmint.wms_conthdr_key as "PalletNumber",
        null as "CaseNumber",
        pmint.in_item_key as "ItemNumber",
        pmint.wms_pmint_uom as "PalletUoM",
        pmint.wms_pmint_bqty as "PalletVolume",
        null as "CaseUoM",
        null as "CaseVolume",
        1::float as "FWtoLBConversion",
        'Output' as "TransactionType",
        'VA Tub' as "ItemProfile",
        pmint.dbserverdatetime as "dbDT",
        pmint.trans_date as "DateTime_Transaction",
        pmint.wms_contdtl_key as "Key_Contdtl",
        coalesce(
            pmint.pieces,
            -1 * first_value(pisub.pieces ignore nulls)
                over (partition by pmint.wms_conthdr_key order by pisub.pieces)
        ) as "Pieces",
        case
            when pmint.wms_pmint_uom = 'CASE'
                then (pmint.wms_pmint_bqty * coalesce(lbconv.conversionvalue, 0))
            when pmint.wms_pmint_uom = 'LB'
                then pmint.wms_pmint_bqty
            when pmint.wms_pmint_uom = 'KG'
                then (pmint.wms_pmint_bqty * csconv.conversionvalue)
            else 0
        end as "Lbs",
        case
            when pmint.wms_pmint_uom = 'case'
                then pmint.wms_pmint_bqty
            when pmint.wms_pmint_uom = 'KG'
                then 1
            when pmint.wms_pmint_uom = 'LB'
                then 1
            else round(pmint.wms_pmint_bqty * csconv.conversionvalue, 0)
        end as "Units",
        case
            when itsetitems.itemsk is null
                then 'InvalidOutputItem'
            else 'ValidOutputItem'
        end as "ItemSetCheck",
        to_date(pmint.trans_date) as "Date_Transaction",
        'NS_' || item.dataentitycompany_sk as "Key_Company",
        'NS_' || site.sitesk as "Key_Site",
        to_date(pmint.trans_date) as "Key_Date",
        'NS_' || coalesce(item.item_sk, 'IncorrectDivision') as "Key_Item",
        'CE_' || pmint.gl_cmp_key || '_' || iff(coalesce(pmint.in_lot_key, 'MissingLot') = '', 'MissingLot', pmint.in_lot_key) as "Key_Lot",
        'CE_' || trim(pmint.wms_line_key) as "Key_Line",
        right(cdtl.wms_contdtl_alloc, charindex('_', reverse(cdtl.wms_contdtl_alloc)) - 1) as "Allocation"

    from wms_pmint_tbl as pmint

    left join wms_pmintdtl_tbl as pmd
        on pmint.wms_conthdr_key = pmd.wms_conthdr_key
            and pmd.gl_cmp_key = 'TNS'

    left join wms_contdtl_tbl as cdtl
        on pmint.wms_conthdr_key = cdtl.wms_conthdr_key
            and pmint.wms_contdtl_key = cdtl.wms_contdtl_key
            and cdtl.gl_cmp_key = 'TNS'
            and cdtl.in_whs_key in ('FBD', 'MACH', 'HERM', 'BLKS')

    left join im_item_attribute_values as item
        on pmint.in_item_key = item.item_id
            and item.dataentitycompany_sk = 1
            and item."Division" = 'TNS'

    left join erpx_im_item as imi
        on item.item_sk = imi.itemsk
            and item.dataentitycompany_sk = 1
            and item."Division" = 'TNS'
            and imi.dataentitycompanysk = 1

    left join erpx_im_uom_schedule_conversion_value as csconv
        on imi.uomschedulesk = csconv.uomschedulesk
            and pmint.wms_pmint_uom = csconv.fromuomid
            and csconv.touomsk = '870'

    left join erpx_im_uom_schedule_conversion_value as lbconv
        on imi.uomschedulesk = lbconv.uomschedulesk
            and pmint.wms_pmint_uom = upper(lbconv.fromuomid)
            and lbconv.touomsk = '869'

    left join erpx_mf_site as site
        on pmint.in_whs_key = site.hostsystemlink
            and site.dataentitycompanysk = 1

    left join wm_production_line_def as prodl
        on pmint.wms_line_key = prodl.linekey
            and prodl.company = 'TNS'

    {# select *, trim(substring(prodl.linedescription, charindex('- ', prodl.linedescription) + 1, len(prodl.linedescription))) 
    from {{ ref('stg_coolearth__wm_production_line_def') }} prodl
    where trim(company) = 'TNS' and linekey = 3003

    select * from {{ ref('stg_northscope__erpx_im_itemset') }}
    where trim(itemsetname) like '%burg%'

    select * from {{ ref('stg_northscope__erpx_im_itemset_items') }} #}

    left join erpx_im_itemset as itemset
        on trim(substring(prodl.linedescription, charindex('- ', prodl.linedescription) + 1, len(prodl.linedescription))) = itemset.itemsetname
            and itemset.dataentitycompanysk = 1

    left join erpx_im_itemset_items as itsetitems
        on itemset.itemsetsk = itsetitems.itemsetsk
            and item.item_sk = itsetitems.itemsk

    left join wms_pmint_tbl as pisub
        on pmint.wms_conthdr_key = pisub.wms_conthdr_key

    /*******************************************************************************************************************************************
    WHERE condition notes:
            The SSRS assets are limited to just the current and previous month.
            Also keep in mind that within the JOIN conditions into the Item Attribute Values
            we're limiting the results to only include TNS company & TNS division items. That explicitly excludes AFS and AC Covert divisions
    *******************************************************************************************************************************************/
    where pmint.gl_cmp_key = 'TNS'
        and pmint.in_whs_key in ('FBD', 'MACH', 'HERM', 'BLKS')
        and pmd.wms_conthdr_key is null

)

select * from int_tn_fresh_yield_reporting__processing_outputs_pallets
/* For Testing */
--where "PalletNumber" = '11906286'
