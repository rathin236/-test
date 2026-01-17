with

source as (

    select * from {{ source('erequester_dbo', 'requisitionauth') }}

),

renamed as (

    select
        authority,
        requisitionid,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
