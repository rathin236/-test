with

source as (

    select * from {{ source('d365_ce', 'user_alias') }}

),

renamed as (

    select
        company,
        status,
        trim(d365) as d365,
        trim(crm) as crm

    from source

)

select * from renamed
