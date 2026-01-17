with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimvendor') }}

),

renamed as (

    select

        dimvendorid,
        vendorcompanycodename,
        vendorname,
        modifiedetlrunid,
        hasmsc,
        bscistatus,
        vendorcountryname,
        hasglobalgap,
        hasorganic,
        bk_vendorid,
        hasasc,
        hasbap,
        createdetlrunid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
