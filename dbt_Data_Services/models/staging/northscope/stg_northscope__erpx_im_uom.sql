with source as (

    select * from {{ source('northscope', 'erpx_imuom') }}

),

renamed as (

    select
        issystemuom,
        lastupdated,
        dataentitycompanysk,
        isinactive,
        lastuser,
        hostsystemlink,
        _fivetran_deleted,
        _fivetran_synced,
        lower(uomid) as uomid,
        lower(uomname) as uomname,
        trim(uomtypesk) as uomtypesk,
        trim(uomsk) as uomsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
