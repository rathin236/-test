with containers as (
    select * from {{ ref('stg_fishtalk__containers') }}
),

organisation_unit as (
    select * from {{ ref('stg_fishtalk__organisation_unit') }}
),

ext_containers_v2 as (
    select

        con.containerid,
        con.containername,
        con.groupid,
        con.orgunitid,
        con.containertype as typeid,
        con.containerfeedingmethod as feedmethodid,
        con.standid,
        con.sortindex,
        orgu.active,
        case
            when con.groupid is null
                and con.standid is null then con.orgunitid
            else coalesce(con.standid, con.groupid)
        end as parentid

    from containers as con

    inner join organisation_unit as orgu
        on con.orgunitid = orgu.orgunitid

    where orgu.orgunittypeid != 'A409F5FE-D15A-4D68-99FE-38749C49CE25'

)

select * from ext_containers_v2
