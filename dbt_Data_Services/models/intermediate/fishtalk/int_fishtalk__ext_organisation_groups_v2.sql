with organisation_unit_groupings as (
    select * from {{ ref('stg_fishtalk__organisation_unit_groupings') }}
),

organisation_unit as (
    select * from {{ ref('stg_fishtalk__organisation_unit') }}
),

ext_organisation_groups_v2 as (
    select

        oug.groupid,
        oug.name as groupname,
        oug.parent,
        case
        orgu.orgunittypeid
            when '64CD1744-1E7E-49FD-A92D-A5EC863985E5' then 'Container Group'
            when '71CE8CDB-79EE-4293-B2B9-D06ADD64896E' then 'Company Group'
        end as grouptype

    from organisation_unit_groupings as oug

    inner join organisation_unit as orgu
        on oug.parent = orgu.orgunitid

)

select * from ext_organisation_groups_v2
