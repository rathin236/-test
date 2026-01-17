with view_harvest_catch_curve as (
    select distinct
        apii.curvename,
        loc.dimension as country,
        spe.dimension as species,
        uni.dimension as unit,
        apii.year,
        apii.month,
        apii.timestamp,
        apii.updated_at,
        case
            when uni.dimension = 'Tonnes' then apii.curve_val
            else 0
        end as harvest_volume,
        case
            when uni.dimension = 'Kilogram' then apii.curve_val
            else 0
        end as average_harvest_weight
    from {{ ref('int_kontali_curve_api_response') }} as apii
    inner join
        {{ ref('int_kontali_category_location') }} as loc
        on apii.curvename = loc.curvename
    left join
        {{ ref('int_kontali_category_species') }} as spe
        on apii.curvename = spe.curvename
    left join
        {{ ref('int_kontali_category_units') }} as uni
        on apii.curvename = uni.curvename
    where apii.curvecategory in ('Harvest', 'Catch')
)

select * from view_harvest_catch_curve
