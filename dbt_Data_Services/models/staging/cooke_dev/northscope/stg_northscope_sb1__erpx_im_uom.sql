with source as (

    select * from {{ source('northscope_sb1', 'erpx_imuom') }}

),

renamed as (

    select
        issystemuom,
        lastupdated,
        dataentitycompanysk,
        isinactive,
        uomid,
        lastuser,
        hostsystemlink,
        uomname,
        _fivetran_deleted,
        _fivetran_synced,
        trim(uomtypesk) as uomtypesk,
        trim(uomsk) as uomsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
