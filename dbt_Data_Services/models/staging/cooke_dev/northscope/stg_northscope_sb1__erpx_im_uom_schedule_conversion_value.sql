with source as (

    select * from {{ source('northscope_sb1', 'erpx_imuomscheduleconversionvalue') }}

),

renamed as (

    select
        conversionvalue,
        scheduleid,
        isinactive,
        dataentitycompanysk,
        _fivetran_deleted,
        _fivetran_synced,
        trim(uomschedulesk) as uomschedulesk,
        trim(fromuomsk) as fromuomsk,
        trim(touomid) as touomid,
        trim(fromuomtypesk) as fromuomtypesk,
        trim(touomsk) as touomsk,
        trim(touomtypesk) as touomtypesk,
        trim(fromuomid) as fromuomid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
