with

source as (

    select * from {{ source('concur', 'policy') }}

),

renamed as (

    select
        id,
        is_default,
        is_inheritable,
        name,
        _fivetran_synced
    from source

)

select * from renamed
