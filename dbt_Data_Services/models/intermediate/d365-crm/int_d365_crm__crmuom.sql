with crmuom as ( --cte to get all crm active/under revision products

    select distinct
        'EXIST' as status,
        'CRM' as source,
        'TNSF' as company,
        uos.description,
        uos.uomscheduleid,
        uom.uomid,
        upper(uos.name) as unitgroupname,
        upper(uos.baseuomname) as baseunitname,
        split_part(uos.name, '-', 2) as productid

    from {{ ref('stg_crm_dev3__uomschedule') }} as uos
    left join {{ ref('stg_crm_dev3__uom') }} as uom on uos.uomscheduleid = uom._uomscheduleid_value and uom.isschedulebaseuom = 'TRUE'

)

select * from crmuom
