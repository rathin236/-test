with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimcostcenter') }}

),

renamed as (

    select

        dimcostcenterid,
        profitcenter,
        businessarea,
        modifiedetlrunid,
        personresponsible,
        bk_controllingareaid,
        businessareaname,
        bk_costcenterid,
        costcentername,
        controllingareaname,
        profitcentername,
        createdetlrunid,
        companycode,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
