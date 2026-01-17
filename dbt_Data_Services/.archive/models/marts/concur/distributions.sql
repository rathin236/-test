with distributions as (

    select * from {{ ref('int_concur__distributions') }}

)

select * from distributions
