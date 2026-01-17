with crmunits as ( --cte to get all crm active/under revision uom
    select distinct
        'EXIST' as status,
        'CRM' as source,
        'TNSF' as company,
        uom.quantity as conversionfactor,
        uos.uomscheduleid as uomscheduleeditlink,
        _baseuom_value as defaultuomid,
        upper(uos.name) as unitgroup,
        upper(uos.baseuomname) as baseunit,
        upper(uom.unitname) as fromunit,
        upper(uos.baseuomname) as tounit,
        upper(split(uos.name, '-')[1]) as productid

    from
        {{ ref('stg_crm_dev3__uom') }} as uom
    left join {{ ref('stg_crm_dev3__uomschedule') }} as uos on uom._uomscheduleid_value = uos.uomscheduleid
)

select * from crmunits
