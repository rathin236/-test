with

d365uom as (  -- CTE to get all D365 units and unit conversions

    select distinct
        'EXIST' as status,
        'D365' as source,
        itb.itemid as productid,
        'D365 Product Unit Group' as description,
        null as uomscheduleid,
        null as uomid,
        itb.dataareaid as company,
        upper(itm.unitid) as baseunitname,
        upper(itm.unitid || '-' || itb.itemid) as unitgroupname

    from {{ ref("stg_finops_adls_crp__invent_table_module") }} as itm
    left join
        {{ ref("stg_finops_adls_crp__invent_table") }} as itb
        on itm.itemid = itb.itemid and itm.dataareaid = itb.dataareaid and itb.prodlifecyclestateid = 'IsActiveForPlanning'
    left join
        {{ ref("stg_finops_adls_crp__eco_res_product") }} as eco
        on itb.itemid = eco.displayproductnumber
    inner join
        {{ ref("stg_finops_adls_crp__invent_item_group_item") }} as itg
        on lower(itb.dataareaid) = lower(itg.itemdataareaid) and itb.itemid = itg.itemid and itg.itemgroupid
            not in ({{ var('crm_d365_item_group_id_banned') }})
    where itm.unitid is not null and itm.moduletype = '0'
)

select * from d365uom
