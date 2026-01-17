with view_import_curve as (
    select distinct
        apii.curvename,
        des.dimension as market,
        org.dimension as supply_source,
        spe.dimension as species,
        --prev.dimension as Preservation,
        --prep.dimension as prepration,
        --pp.dimension as presentaion,
        apii.year,
        apii.month,
        apii.timestamp,
        apii.updated_at,
        apii.curve_val as product_weight,
        uni.dimension as unit,
        case
            when prep.dimension != '' then concat(prev.dimension, ' ', prep.dimension)
            else concat(prev.dimension, ' ', pap.dimension)
        end as productype
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
    left join
        {{ ref('int_kontali_category_Preparation') }} as prep
        on apii.curvename = prep.curvename
    left join
        {{ ref('int_kontali_category_preservation') }} as prev
        on apii.curvename = prev.curvename
    left join
        {{ ref('int_kontali_category_presentation') }} as pap
        on apii.curvename = pap.curvename
    where apii.curvecategory = 'Import'
)

select * from view_import_curve
