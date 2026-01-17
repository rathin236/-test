with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimglaccount') }}

),

renamed as (

    select

        dimglaccountid,
        glaccountcode,
        bk_chartofaccountsid,
        balancesheetaccountindicator,
        modifiedetlrunid,
        glaccountname,
        bk_glaccountid,
        plstatementaccounttype,
        createdetlrunid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
