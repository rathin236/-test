with

source as (

    select * from {{ source('concur', 'payment_type') }}

),

renamed as (

    select
        id,
        is_default,
        name,
        _fivetran_synced

    from source

)

select * from renamed
