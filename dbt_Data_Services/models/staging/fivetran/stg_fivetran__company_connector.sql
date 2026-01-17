with

source as (

    select * from {{ source('fivetran', 'company_connector') }}

),

renamed as (

    select
        id,
        company_id,
        connector_id,
        destination_id,
        application_id

    from source

)

select * from renamed
