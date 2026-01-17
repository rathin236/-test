with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimcurrency') }}

),

renamed as (

    select

        dimcurrencyid,
        bk_currencyid,
        modifiedetlrunid,
        createdetlrunid,
        currencyname,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
