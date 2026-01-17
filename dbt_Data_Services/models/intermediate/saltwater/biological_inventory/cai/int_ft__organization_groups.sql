with organisation_unit_groupings as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit_groupings') }}
    from {{ ref('stg_fishtalk__organisation_unit_groupings') }}
),

organisation_unit as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit') }}
    from {{ ref('stg_fishtalk__organisation_unit') }}
),

final as (
    select
        oug.groupid as group_id,
        oug.name as group_name,
        oug.parent,
        case
        ogu.orgunittypeid
            when '64cd1744-1e7e-49fd-a92d-a5ec863985e5' then 'Container Group'
            when '71ce8cdb-79ee-4293-b2b9-d06add64896e' then 'Company Group'
        end as group_type
    from organisation_unit_groupings as oug
    inner join organisation_unit as ogu
        on oug.parent = ogu.orgunitid
)

select * from final
