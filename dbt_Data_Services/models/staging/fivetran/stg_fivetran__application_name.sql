with

source as (

    select * from {{ source('fivetran', 'application_name') }}

),

renamed as (

    select
        id as application_id,
        application_name,
        application_category as application_tier,
        application_environment

    from source

)

select * from renamed
