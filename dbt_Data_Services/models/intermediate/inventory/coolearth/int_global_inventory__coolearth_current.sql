with
wms_bindtlst_tbl as (
    select * from {{ ref('stg_coolearth__wms_bindtlst_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
        and wms_contdtl_qty <> 0
        and wms_contdtl_qty is not null
),

wms_contdtl_tbl as (
    select * from {{ ref('stg_coolearth__wms_contdtl_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
        and wms_contdtl_qty <> 0
        and wms_contdtl_qty is not null
),

wms_lot_tbl as (
    select * from {{ ref('stg_coolearth__wms_lot_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
),

wms_conthdr_tbl as (
    select * from {{ ref('stg_coolearth__wms_conthdr_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
),

wms_pmint_tbl as (
    select * from {{ ref('stg_coolearth__wms_pmint_tbl') }}
    where trim(gl_cmp_key) = 'TNS'
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
),

label_date as (
    select
        wms_conthdr_key,
        wms_contdtl_key,
        in_whs_key,
        min(wms_contdtl_prddt) as label_date
    from wms_contdtl_tbl
    group by 1, 2, 3
),

lot_date as (
    select distinct
        en_lot_key,
        owner,
        dateadd(day, juliandate - 1, dateadd(year, julianyear - 2000, '1/1/2000')) as lot_date,
        coalesce(certifications, '') as certifications
    from wms_lot_tbl
),

ch as (
    select distinct
        wms_conthdr_key,
        wms_contty_key
    from wms_conthdr_tbl
    where wms_bin_key not in ('SHIPPED', 'DELETED')
),

vawhs as (
    select distinct
        in_whs_key,
        wms_conthdr_key
    from wms_pmint_tbl as pmint
    where wms_pmint_crdt = (
            select min(pmint_crdt.wms_pmint_crdt)
            from wms_pmint_tbl as pmint_crdt
            where trim(pmint_crdt.wms_conthdr_key) = trim(pmint.wms_conthdr_key)
        )
),

tns as (
    select
        iav.item_sk,
        lot_date.certifications as lotcertifications,
        cdtl.wms_contdtl_ctwgt,
        lb_conv.conversionvalue,
        to_varchar(site.sitesk) as warehouse_sk,
        trim(bdt.in_whs_key) as in_whs_key,
        trim(cdtl.in_item_key) as in_item_key,
        trim(cdtl.in_lot_key) as in_lot_key,
        trim(bdt.wms_conthdr_key) as wms_conthdr_key,
        trim(bdt.wms_bin_key) as wms_bin_key,
        to_date(to_varchar(label_date.label_date, 'MM/DD/YYYY'), 'MM/DD/YYYY') as label_date,
        dateadd(day, imit.expirationdays, to_date(to_varchar(label_date.label_date, 'MM/DD/YYYY'), 'MM/DD/YYYY')) as expiry_date,
        coalesce(trim(lot_date.certifications), 'NoCertification') as certifications,
        case
            when trim(ch.wms_contty_key) in ('TOTE1000', 'TOTE2000', 'Xactics') then 'Tub'
            else cdtl.wms_contdtl_uom
        end as wms_contdtl_uom,
        case
            when cdtl.wms_contdtl_uom = 'KG' then 1
            else cdtl.wms_contdtl_qty
        end as wms_contdtl_qty,
        case
            when cdtl.wms_contdtl_uom = 'KG' then 1
            when trim(ch.wms_contty_key) in ('TOTE1000', 'TOTE2000', 'Xactics') then 1
            else cdtl.wms_contdtl_qty
        end as "Cases",
        case
            when bdt.wms_contdtl_alloc is null then bdt.wms_contdtl_qty
        end as available_qty,
        case
            when bdt.wms_contdtl_alloc is null then "Cases"
        end as "Available Cases",
        case
            when bdt.wms_contdtl_alloc is not null then bdt.wms_contdtl_qty
        end as picked_qty,
        case
            when bdt.wms_contdtl_alloc is not null then "Cases"
        end as "Picked Cases",
        datediff(day, label_date.label_date, getdate()) as age,
        substring(cdtl.wms_contdtl_alloc, 3, 15) as orderallocation,
        case
            when substring(cdtl.wms_contdtl_alloc, 3, 15) is null then 'No'
            else 'Yes'
        end as allocationtrue,
        {{ convert_to_lb_ce('cdtl.wms_contdtl_uom', 'cdtl.wms_contdtl_qty', 'cdtl.wms_contdtl_ctwgt', 
                        'cdtl.wms_contcase_uom', 'lb_conv.conversionvalue') }} as wms_contdtl_ctwgtlb,
        {{ convert_to_kg_ce('cdtl.wms_contdtl_uom', 'cdtl.wms_contdtl_qty', 'cdtl.wms_contdtl_ctwgt', 
                        'cdtl.wms_contcase_uom', 'lb_conv.conversionvalue') }} as wms_contdtl_ctwgtkg,
        case
            when bdt.wms_contdtl_alloc is null then wms_contdtl_ctwgtlb
        end as "Available LBs",
        case
            when bdt.wms_contdtl_alloc is not null then wms_contdtl_ctwgtlb
        end as "Picked LBs",
        datediff(day, lot_date.lot_date, getdate()) as lotage,
        trim(iav.division) as division,
        trim(coalesce(lot_date.owner, 'NoOwner')) as owners,
        trim(cdtl.wms_contst_key) as holdstatus,
        trim(cdtl.wms_user_paramvc2) as "Inv Commitment Value",
        row_number() over (
            partition by
                trim(warehouse_sk),
                trim(bdt.wms_conthdr_key),
                trim(bdt.in_lot_key),
                trim(bdt.in_item_key),
                label_date
            order by bdt.wms_contdtl_qty desc
        ) as rn
    from wms_bindtlst_tbl as bdt

    left join
        wms_contdtl_tbl as cdtl
        on trim(bdt.wms_conthdr_key) = trim(cdtl.wms_conthdr_key)
            and trim(bdt.wms_contdtl_key) = trim(cdtl.wms_contdtl_key)

    left join item_attribute_value as iav
        on trim(cdtl.in_item_key) = trim(iav.item_id)
            and trim(iav.source_system) = 'TNS'
            and trim(iav.sub_category) <> 'Gel Packs'

    left join lot_date
        on trim(cdtl.in_lot_key) = trim(lot_date.en_lot_key)

    inner join label_date
        on trim(cdtl.wms_conthdr_key) = trim(label_date.wms_conthdr_key)
            and trim(cdtl.wms_contdtl_key) = trim(label_date.wms_contdtl_key)
            and trim(cdtl.in_whs_key) = trim(label_date.in_whs_key)

    inner join ch
        on trim(cdtl.wms_conthdr_key) = trim(ch.wms_conthdr_key)

    left join vawhs
        on trim(bdt.wms_conthdr_key) = trim(vawhs.wms_conthdr_key)

    inner join erpx_im_item as imit
        on trim(iav.item_sk) = trim(imit.itemsk)
            and trim(imit.dataentitycompanysk) = 1

    left join site
        on trim(bdt.in_whs_key) = trim(site.siteid)
            and site.dataentitycompanysk = 1

    left join lb_conv
        on trim(imit.uomschedulesk) = trim(lb_conv.uomschedulesk)
            and upper(trim(cdtl.wms_contdtl_uom)) = upper(trim(lb_conv.fromuomid))
            and trim(lb_conv.touomsk) = '869'

    where cdtl.wms_contdtl_qty > 0
        and coalesce(trim(bdt.wms_bin_key), 'XXX') not in ('SHIPPED', 'DELETED', 'MISSING')
    qualify rn = 1
)

select * from tns
