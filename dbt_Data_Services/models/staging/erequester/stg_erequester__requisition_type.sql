with

source as (

    select * from {{ source('erequester_dbo', 'requisitiontype') }}

),

renamed as (

    select
        requisitiontypeid,
        description,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
