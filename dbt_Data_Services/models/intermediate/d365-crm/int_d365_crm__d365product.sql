with
d365product as (  -- cte to get all d365 released products
    select distinct
        'D365' as source,
        itb.dataareaid as company,
        eco.producttype as productstructure,
        1 as producttype,
        itb.itemid as productid,
        ect.prodname as productdesc,
        null as gpproductid,
        itb.itemid as d365productid,
        null as crmproductid,
        null as uomscheduleid,
        null as uomid,
        cpa.attributevalue as companyid,
        itb.prodlifecyclestateid as statusuid,
        null as parentproductid_value,
        upper(itm.unitid) as unit,
        (case when itm.unitid is null then 'ERROR' else 'EXIST' end) as status,
        upper(itm.unitid || '-' || itb.itemid) as unitgroup

    from {{ ref("stg_finops_adls_crp__invent_table_module") }} as itm
    left join
        {{ ref("stg_finops_adls_crp__invent_table") }} as itb
        on itm.itemid = itb.itemid and itm.dataareaid = itb.dataareaid
    left join
        {{ ref("stg_finops_adls_crp__eco_res_product") }} as eco
        on itb.itemid = eco.displayproductnumber
    left join
        {{ ref("stg_finops_adls_crp__eco_res_product_translation") }} as ect
        on eco.recid = ect.recid
    left join
        {{ ref("stg_crm_dev3__stringmap") }} as cpa
        on itb.dataareaid = cpa.activevalue and cpa.attributename = 'cai_company'  -- and cpa.objecttypecode = 'product'
    inner join
        {{ ref('stg_finops_adls_crp__invent_item_group_item') }} as itg
        on lower(itm.dataareaid) = lower(itg.itemdataareaid) and itm.itemid = itg.itemid and itg.itemgroupid
            not in ({{ var("crm_d365_item_group_id_banned") }})

    where itm.moduletype = '0' --and eco.producttype = 1

)

select *
from d365product
