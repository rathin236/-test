with source as (

    select * from {{ source('northscope_sb1', 'erpx_imuomschedule') }}

),

renamed as (

    select
        lastupdated,
        description,
        uomschedulesk,
        baseuomid,
        dataentitycompanysk,
        decimalplaces,
        hostsystemlink,
        lastuser,
        scheduleid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
