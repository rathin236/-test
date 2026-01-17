with d365units as (
    select distinct
        'EXIST' as status,
        'D365' as source,
        itb.itemid as productid,
        umc.factor as conversionfactor,
        '' as uomscheduleeditlink,
        itb.dataareaid as company,
        upper(itm.unitid) as baseunit,
        upper(uom.symbol) as fromunit,
        upper(uomto.symbol) as tounit,
        upper(trim(itm.unitid) || '-' || trim(itb.itemid)) as unitgroup,
        upper(uomto.symbol) as defaultuomid
    from
        {{ ref('stg_finops_adls_crp__unit_of_measure_conversion') }} as umc
    inner join {{ ref('stg_finops_adls_crp__invent_table') }} as itb on umc.product = itb.product
    left join {{ ref('stg_finops_adls_crp__invent_table_module') }} as itm on itb.itemid = itm.itemid and itm.moduletype = '0'
    left join {{ ref('stg_finops_adls_crp__unit_of_measure') }} as uom on umc.fromunitofmeasure = uom.recid
    left join {{ ref('stg_finops_adls_crp__unit_of_measure') }} as uomto on umc.tounitofmeasure = uomto.recid
    inner join
        {{ ref('stg_finops_adls_crp__invent_item_group_item') }} as itg
    on lower(itm.dataareaid) = lower(itg.itemdataareaid)
        and itm.itemid = itg.itemid
        and itg.itemgroupid not in ({{ var('crm_d365_item_group_id_banned') }})
    where
        itm.unitid || '-' || itb.itemid is not null
)

select * from d365units
