with wms_piint_tbl as (
    select * from {{ ref('stg_coolearth__wms_piint_tbl') }}
),

im_item_attribute_values as (
    select * from {{ ref('item_attribute_values') }}
),

erpx_im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),

erpx_im_uom_schedule_conversion_values as (
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

int_tn_fresh_yield_reporting__processing_inputs_ns as (

    /* This section grabs production inputs from Coolearth */
    select

        piint.gl_cmp_key as "Company",
        piint.in_whs_key as "Facility",
        piint.wms_conthdr_key as "PalletNumber",
        null as "CaseNumber",
        piint.in_item_key::string as "ItemNumber",
        piint.wms_piint_uom as "PalletUoM",
        piint.wms_piint_bqty as "PalletVolume",
        piint.wms_ctwgt_uom as "CaseUoM",
        piint.wms_piint_ctwgt as "CaseVolume",
        piint.pieces as "Pieces",
        lbconv.conversionvalue::float as "FWtoLBConversion",
        'Input' as "TransactionType",
        piint.dbserverdatetime as "dbDT",
        piint.trans_date as "DateTime_Transaction",
        piint.wms_contdtl_key as "Key_Contdtl",
        piint.trans_date as "Key_Date",
        case
            when piint.wms_piint_uom = 'LB' and piint.wms_ctwgt_uom not in ('LB', 'KG') --RW Pallet
                then piint.wms_piint_bqty
            when piint.wms_piint_uom = 'KG' and piint.wms_ctwgt_uom not in ('LB', 'KG') --RW Pallet
                then (piint.wms_piint_bqty * 2.2046)
            when piint.wms_ctwgt_uom = 'LB' and piint.wms_piint_uom not in ('LB', 'KG') --RW cases
                then piint.wms_piint_ctwgt
            when piint.wms_ctwgt_uom = 'KG' and piint.wms_piint_uom not in ('LB', 'KG') --RW cases
                then (piint.wms_piint_ctwgt * 2.2046)
            when piint.wms_piint_uom in ('CASE', 'EACH') and piint.wms_ctwgt_uom not in ('LB', 'KG') --FW Units
                then (piint.wms_piint_bqty * lbconv.conversionvalue)
            else 0
        end::float as "Lbs",
        to_date(piint.trans_date) as "Date_Transaction",
        case
            when piint.wms_piint_uom = 'CASE'
                then piint.wms_piint_bqty
            else 1
        end as "Units",
        case
            when piint.wms_piint_uom in ('LB', 'KG') and piint.wms_ctwgt_uom not in ('LB', 'KG')
                then 'RW Pallet'
            when piint.wms_ctwgt_uom in ('LB', 'KG') and piint.wms_piint_uom not in ('LB', 'KG')
                then 'RW cases'
            when piint.wms_piint_uom in ('CASE', 'EACH') and piint.wms_ctwgt_uom not in ('LB', 'KG')
                then 'FW Units'
            else 'Unknown item Profile'
        end as "ItemProfile",
        case
            when itemset.itemsetsk is null
                then 'InvalidInputItem'
            else 'ValidInputItem'
        end as "ItemSetCheck",
        'NS_' || item.dataentitycompany_sk as "Key_Company",
        'NS_' || site.sitesk as "Key_Site",
        'NS_' || item.item_sk as "Key_Item",
        'CE_' || piint.gl_cmp_key || '_' || piint.in_lot_key as "Key_Lot",
        'CE_' || piint.wms_line_key as "Key_Line"

    from wms_piint_tbl as piint

    inner join im_item_attribute_values as item
        on piint.in_item_key = item.item_id
            and item.dataentitycompany_sk = 1
            and item."Division" = 'TNS'

    left join erpx_im_item as imi
        on item.item_sk = imi.itemsk

    left join erpx_im_uom_schedule_conversion_values as lbconv
        on imi.uomschedulesk = lbconv.uomschedulesk
            and lower(piint.wms_piint_uom) = lbconv.fromuomid
            and lbconv.touomid = 'lb'

    left join erpx_mf_site as site
        on piint.in_whs_key = site.hostsystemlink
            and site.dataentitycompanysk = 1

    left join wm_production_line_def as pline
        on piint.wms_line_key = pline.linekey
            and pline.company = 'TNS'

    left join erpx_im_itemset as itemset
        on trim(substring(pline.linedescription, charindex('- ', pline.linedescription) + 1, len(pline.linedescription))) = itemset.itemsetname
            and itemset.dataentitycompanysk = 1

    /*******************************************************************************************************************************************
    where condition notes:
            The SSRS assets are limited to just the current and previous month.
            Also keep in mind that within the JOin conditions into the item Attribute Values
            We're limiting the results to only include TNS company & TNS division items. That explicitly excludes AFS and AC Covert divisions
    *******************************************************************************************************************************************/
    where piint.gl_cmp_key = 'TNS'

)

select * from int_tn_fresh_yield_reporting__processing_inputs_ns
