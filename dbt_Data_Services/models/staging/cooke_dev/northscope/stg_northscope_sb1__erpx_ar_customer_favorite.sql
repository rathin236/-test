with source as (

    select * from {{ source('northscope_sb1', 'erpx_arcustomerfavorite') }}

),

renamed as (

    select
        lineitemsort,
        lastupdated,
        lastuser,
        units,
        customeritemdescription,
        customeritemid,
        weight,
        _fivetran_deleted,
        _fivetran_synced,
        trim(weightuomsk) as weightuomsk,
        trim(itemsk) as itemsk,
        trim(priceuomsk) as priceuomsk,
        trim(itemtypesk) as itemtypesk,
        trim(dataentitycompanysk) as dataentitycompanysk,
        trim(customerfavoritesk) as customerfavoritesk,
        trim(unitsuomsk) as unitsuomsk,
        trim(customerentitysk) as customerentitysk,
        trim(customerfavoritetypesk) as customerfavoritetypesk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
