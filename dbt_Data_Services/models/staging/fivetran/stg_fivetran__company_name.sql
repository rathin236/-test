with

source as (

    select * from {{ source('fivetran', 'company_name') }}

),

renamed as (

    select
        country,
        region,
        trim(id) as company_id,
        trim(company_name) as company_name

    from source

)

select * from renamed
