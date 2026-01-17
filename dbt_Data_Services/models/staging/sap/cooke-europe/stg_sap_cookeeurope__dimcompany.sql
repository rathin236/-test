with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimcompany') }}

),

renamed as (

    select

        dimcompanyid,
        companycountryname,
        companyname,
        createdetlrunid,
        bk_companyid,
        modifiedetlrunid,
        currency,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
