with

source as (

    select * from {{ source('feeddata', 'site_info') }}

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
