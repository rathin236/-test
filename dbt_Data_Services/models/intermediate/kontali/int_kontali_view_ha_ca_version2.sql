with kg as (
    select *
    from {{ ref('int_kontali_view1_ha_ca') }}
    where unit = 'Kilogram'
),

tn as (
    select *
    from {{ ref('int_kontali_view1_ha_ca') }}
    where unit = 'Tonnes'
),

final_output as (
    select
        tonns.curvename,
        --kg.curvename,
        tonns.country,
        tonns.species,
        --tonns.unit,
        tonns.year,
        tonns.month,
        tonns.timestamp,
        tonns.updated_at,
        tonns.harvest_volume,
        kg.average_harvest_weight
    from tn as tonns
    left join kg on tonns.country = kg.country
        and tonns.species = kg.species
        and tonns.month = kg.month
        and tonns.year = kg.year
)

select * from final_output
