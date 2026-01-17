with bp as (

    select * from {{ ref("int_business_partners__unioned") }}

)

select * from bp
