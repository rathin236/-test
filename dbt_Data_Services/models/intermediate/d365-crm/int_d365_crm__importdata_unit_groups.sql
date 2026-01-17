with importdata as ( --cte to compare d365 uom agains crm uom, and flag the records that needs to be created as new. no need for update.
    select
        uos.uomscheduleid,
        uom.uomid,
        (case when (d365uom.productid = crmuom.productid) then 'EXIST' else 'NEW' end) as status,
        coalesce(d365uom.source, crmuom.source) as source,
        coalesce(d365uom.company, crmuom.company) as company,
        coalesce(d365uom.productid, crmuom.productid) as productid,
        upper(coalesce(d365uom.unitgroupname, crmuom.unitgroupname)) as unitgroupname,
        upper(coalesce(d365uom.baseunitname, crmuom.baseunitname)) as baseunitname,
        coalesce(d365uom.description, crmuom.description) as description

    from {{ ref('int_d365_crm__d365uom') }} as d365uom
    left join
        {{ ref('int_d365_crm__crmuom') }} as crmuom
        on d365uom.company = crmuom.company and d365uom.productid = crmuom.productid and upper(d365uom.unitgroupname) = upper(crmuom.unitgroupname)
    left join {{ ref('stg_crm_dev3__uomschedule') }} as uos on trim(split_part(uos.name, '-', 2)) = d365uom.productid
    left join {{ ref('stg_crm_dev3__uom') }} as uom on uos.uomscheduleid = uom._uomscheduleid_value and uom.isschedulebaseuom = 'TRUE'
    where crmuom.productid is null --uom are new

)

select * from importdata
