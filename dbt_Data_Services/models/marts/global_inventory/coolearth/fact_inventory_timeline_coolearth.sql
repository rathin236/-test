with hist as (
    select * from {{ ref('int_global_inventory__coolearth_timeseries') }}
),
lb_conv as (
    select * from {{ ref('stg_northscope__erpx_im_uom_schedule_conversion_value') }}
),
site as (
    select * from {{ ref('stg_northscope__erpx_mf_site') }}
),
erpx_im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),
item_attribute_value as (
    select * from {{ ref('stg_coolearth__vwx_imitemattributevalues') }}
    where trim(source_system) = 'TNS'
),
wms_conthdr_tbl as (
    select * from {{ ref('stg_coolearth__wms_conthdr_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
),
ch as (
    select distinct
        wms_conthdr_key,
        wms_contty_key
    from wms_conthdr_tbl
    --where wms_bin_key not in ('SHIPPED', 'DELETED')
),

quantity_converted as (
    select
        bdt.gl_cmp_key,
        bdt.in_whs_key as warehouse_sk,
        iav.item_sk,
        bdt.in_item_key,
        bdt.wms_conthdr_key,
        bdt.in_lot_key,
        bdt.wms_contdtl_key,
        bdt.wms_contdtl_ctwgt,
        lb_conv.conversionvalue,
        bdt.week_start_date,
        bdt.wms_contdtl_prddt as label_date,
        case
            when trim(ch.wms_contty_key) in ('TOTE1000', 'TOTE2000', 'Xactics') then 'TUB'
            else bdt.wms_contdtl_uom
        end as wms_contdtl_uom,
        case
            when bdt.wms_contdtl_uom = 'KG' then 1
            else bdt.qty
        end as qty,
        case
            when bdt.wms_contdtl_uom = 'KG' then 1
            when trim(ch.wms_contty_key) in ('TOTE1000', 'TOTE2000', 'Xactics') then 1
            else bdt.qty
        end as "Cases",
        {{ convert_to_lb_ce('bdt.wms_contdtl_uom', 'bdt.qty', 'bdt.wms_contdtl_ctwgt', 
                        'bdt.wms_contcase_uom', 'lb_conv.conversionvalue') }} as wms_contdtl_ctwgtlb,
        {{ convert_to_kg_ce('bdt.wms_contdtl_uom', 'bdt.qty', 'bdt.wms_contdtl_ctwgt', 
                        'bdt.wms_contcase_uom', 'lb_conv.conversionvalue') }} as wms_contdtl_ctwgtkg,
    from hist bdt
    left join item_attribute_value as iav 
        on trim(bdt.in_item_key) = trim(iav.item_id)
    inner join ch 
        on trim(bdt.wms_conthdr_key) = trim(ch.wms_conthdr_key)
    inner join erpx_im_item as imit 
        on trim(iav.item_sk) = trim(imit.itemsk)
            and trim(imit.dataentitycompanysk) = 1
    left join lb_conv
        on trim(imit.uomschedulesk) = trim(lb_conv.uomschedulesk)
            and upper(trim(bdt.wms_contdtl_uom)) = upper(trim(lb_conv.fromuomid))
                and trim(lb_conv.touomsk) = '869'
    -- qualify row_number() over (
    --     partition by bdt.in_item_key, bdt.wms_conthdr_key, bdt.in_lot_key, bdt.wms_contdtl_key, bdt.week_start_date
    --     order by wms_contdtl_ctwgtlb desc
    -- ) = 1
),

ce_inventory as (
    select
        'TNS' as "Company",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        fct.week_start_date as "Key_Date",
        fct.warehouse_sk,
        fct.in_lot_key as "Batch Number",
        fct.wms_conthdr_key as "Pallet Number",
        item."Item_SK" as "Item ID",
        fct.wms_contdtl_uom as "Unit of Measure",
        fct.qty as "Balance qty",
        fct."Cases",
        fct.wms_contdtl_ctwgtlb as "Balance LBs",
        fct.wms_contdtl_ctwgtkg as "Balance KGs",
        case
            when to_date(fct.label_date) > fct.week_start_date then 0
            else datediff(day, to_date(fct.label_date), fct.week_start_date)
        end as Age,
        fct.label_date as "Production Date"

    from quantity_converted as fct

    left join {{ ref('dim_item') }} as item
        on fct.item_sk = item."Item_SK"
            and item.sourcesystemcode = 1
    order by "Key_Date"

)

select * from ce_inventory 
-- where  in_item_key = '40355' --and "Batch Number" = 'WC50612' and "Pallet Number" = '100268406' --and WEEK_START_DATE = '2024-08-19' --and wms_conthdr_key = '12046958'
-- and warehouse_sk = 'FBD' 
-- group by week_start_date-- warehouse_sk
-- where "Pallet Number" = '12275737' and "Batch Number" = '26097WC'
-- where "Key_Date" = '2024-09-16'