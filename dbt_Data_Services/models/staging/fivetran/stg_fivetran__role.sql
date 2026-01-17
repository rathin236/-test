with source as (

    select * from {{ source('fivetran', 'role') }}

),

renamed as (

    select
        id,
        name,
        description,
        account_id,
        connector_types,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
