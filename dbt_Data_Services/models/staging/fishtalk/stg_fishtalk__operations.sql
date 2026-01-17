with source as (

    select {{ convert_columns('fishtalk', 'operations') }}
    from {{ source('fishtalk', 'operations') }}

),

renamed as (

    select
        operationid,
        starttime,
        registrationtime,
        registeredby,
        operationtype,
        comment,
        endtime,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
