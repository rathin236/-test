with production_overview as (

    select * from {{ ref('int_cpm_fishtalk__production_overview') }}

)

select * from production_overview
