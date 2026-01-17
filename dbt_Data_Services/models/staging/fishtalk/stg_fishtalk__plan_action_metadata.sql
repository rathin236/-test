with

source as (

    select {{ convert_columns('fishtalk', 'planactionmetadata') }}
    from {{ source('fishtalk', 'planactionmetadata') }}

),

renamed as (

    select
        actionid,
        parameterid,
        parameterdate,
        parametervalue,
        parameterguid,
        parameterstring,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
