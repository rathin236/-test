with

source as (

    select * from {{ source('feeddata', 'company_info') }}

),

renamed as (

    select
        json_data,
        created_date,
        modified_date,
        executionid

    from source

)

select * from renamed
