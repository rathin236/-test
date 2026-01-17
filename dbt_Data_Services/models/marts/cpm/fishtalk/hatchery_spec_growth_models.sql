with hatchery_spec_growth_model as (

    select * from {{ ref('int_cpm_fishtalk__hatchery_spec_growth_models') }}

)

select * from hatchery_spec_growth_model
