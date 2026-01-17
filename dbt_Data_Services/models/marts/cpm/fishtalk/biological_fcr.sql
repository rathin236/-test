with biological_fcr as (

    select * from {{ ref('int_cpm_fishtalk__biological_fcr') }}

)

select * from biological_fcr
