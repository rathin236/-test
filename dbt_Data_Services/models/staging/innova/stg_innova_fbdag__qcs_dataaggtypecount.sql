with

source as (

    select * from {{ source('innova_fbdag', 'qcs_dataaggtypecount') }}

),

renamed as (

    select
        dataagg,
        type,
        triggerlimittotal,
        triggerlimitpieces,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
