with source as (

    select {{ convert_columns('fishtalk', 'actionmetadata') }}
    from {{ source('fishtalk', 'actionmetadata') }}

),

renamed as (

    select
        actionid,
        parameterid,
        parametervalue,
        parameterstring,
        parameterdate,
        parameterguid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
