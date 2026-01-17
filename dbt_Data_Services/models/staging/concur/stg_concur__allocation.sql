with

source as (

    select * from {{ source('concur', 'allocation') }}

),

renamed as (

    select
        itemization_id,
        allocation_id,
        account_code_1 as glaccount,
        custom_4_value as companyname,
        custom_5_value as country,
        custom_2_value as costcenter,
        (percentage / 100) as percentage

    from source

)

select * from renamed
