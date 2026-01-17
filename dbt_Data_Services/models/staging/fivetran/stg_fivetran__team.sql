with source as (

    select * from {{ source('fivetran', 'team') }}

),

renamed as (

    select
        id,
        name,
        description,
        parent_id,
        account_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
