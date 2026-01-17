with source as (

    select * from {{ source('northscope', 'erpx_arcustomersubstituteitem') }}

),

renamed as (

    select
        lastuser,
        sequence,
        customeritemid,
        customeritemdescription,
        lastupdated,
        _fivetran_deleted,
        _fivetran_synced,
        trim(customersubstituteitemsk) as customersubstituteitemsk,
        trim(dataentitycompanysk) as dataentitycompanysk,
        trim(customerfavoritesk) as customerfavoritesk,
        trim(substituteitemsk) as substituteitemsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
