with production_overview_adjusted as (

    select * from {{ ref('int_cpm_fishtalk__production_overview_adjusted') }}

)

select * from production_overview_adjusted
