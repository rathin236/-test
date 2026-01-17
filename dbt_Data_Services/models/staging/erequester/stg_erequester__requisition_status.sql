with

source as (

    select * from {{ source('erequester_dbo', 'requisitionstatus') }}

),

renamed as (

    select
        requisitionstatusid,
        description,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
