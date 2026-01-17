with

source as (

    select {{ convert_columns('fishtalk', 'plansite') }}
    from {{ source('fishtalk', 'plansite') }}

),

renamed as (

    select
        plansiteid,
        lastimportdate,
        version,
        lockuserid,
        flags,
        folderid,
        scenarioid,
        importmode,
        locksessionid,
        locktimestamp,
        orgunitid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
