with generalized_growth_mortality_models as (

    select * from {{ ref('int_cpm_fishtalk__generalized_growth_mortality_models') }}

)

select * from generalized_growth_mortality_models
