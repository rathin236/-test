with
importdata as (  -- cte to compare d365 uom against crm uom, and flag the records that needs to be created as new. no need for update.
    select distinct

        case
            when
                crmuom.unitgroup = pugr.unitgroupname
                then pugr.uomscheduleid
            else ''
        end
            as uomscheduleeditlink,
        (
            case
                when
                    uom.productid = crmuom.productid
                    and uom.tounit = crmuom.tounit
                    and uom.fromunit = crmuom.fromunit
                    then 'EXIST'
                else 'NEW'
            end
        ) as status,
        coalesce(uom.source, crmuom.source) as source,
        coalesce(uom.company, crmuom.company) as company,
        coalesce(uom.productid, crmuom.productid) as productid,
        coalesce(uom.unitgroup, crmuom.unitgroup) as unitgroup,
        coalesce(uom.baseunit, crmuom.baseunit) as baseunit,
        coalesce(uom.fromunit, crmuom.fromunit) as fromunit,
        coalesce(uom.tounit, crmuom.tounit) as tounit,
        coalesce(uom.conversionfactor, crmuom.conversionfactor) as conversionfactor,

        (
            case
                when
                    uom.unitgroup = crmuom.unitgroup
                    then coalesce(crmuom.defaultuomid, pugr.uomid)
                else ''
            end

        ) as defaultuomid

    from {{ ref("int_d365_crm__d365units") }} as uom
    left join
        {{ ref("int_d365_crm__crmunits") }} as crmuom
        on uom.company = crmuom.company
            and uom.productid = crmuom.productid
            and uom.unitgroup = crmuom.unitgroup
            and uom.tounit = crmuom.tounit
            and uom.fromunit = crmuom.fromunit
    left join
        {{ ref("d365_crm__v_product_unit_groups") }} as pugr
        on uom.productid = pugr.productid and crmuom.unitgroup = pugr.unitgroupname
    left join
        {{ ref("stg_finops_adls_crp__invent_table") }} as inv
        on uom.productid = inv.itemid
    where
        coalesce(uom.baseunit, crmuom.baseunit)
        = coalesce(uom.tounit, crmuom.tounit)
        and coalesce(uom.baseunit, crmuom.baseunit)
        != coalesce(uom.fromunit, crmuom.fromunit)
        and coalesce(crmuom.defaultuomid, pugr.uomscheduleid) is not null
        and inv.prodlifecyclestateid = 'IsActiveForPlanning'

),

alldata as (
    select
        uomscheduleeditlink,
        status,
        source,
        company,
        productid,
        unitgroup,
        baseunit,
        fromunit,
        tounit,
        conversionfactor,
        defaultuomid
    from {{ ref("int_d365_crm__d365units") }}
    union all
    select
        uomscheduleeditlink,
        status,
        source,
        company,
        productid,
        unitgroup,
        baseunit,
        fromunit,
        tounit,
        conversionfactor,
        defaultuomid
    from {{ ref("int_d365_crm__crmunits") }}
    union all
    select
        uomscheduleeditlink,
        status,
        source,
        company,
        productid,
        unitgroup,
        baseunit,
        fromunit,
        tounit,
        conversionfactor,
        defaultuomid
    from importdata
)

select *
from alldata
