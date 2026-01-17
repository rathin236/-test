with view_supply_curve as (
    select distinct
        apii.curvename,
        des.dimension as market,
        org.dimension as supply_source,
        spe.dimension as species,
        apii.year,
        apii.month,
        apii.timestamp,
        apii.updated_at,
        apii.curve_val as volume, --noqa
        uni.dimension as unit
        --,api.lastUpdatedate as LastUupdateDate
    from {{ ref('int_kontali_curve_api_response') }} as apii
    inner join
        {{ ref('int_kontali_category_origin') }} as org
        on apii.curvename = org.curvename
    left join
        {{ ref('int_kontali_category_destination') }} as des
        on apii.curvename = des.curvename
    left join
        {{ ref('int_kontali_category_species') }} as spe
        on apii.curvename = spe.curvename
    left join
        {{ ref('int_kontali_category_units') }} as uni
        on apii.curvename = uni.curvename
    where apii.curvecategory = 'Supply'
)

select * from view_supply_curve
