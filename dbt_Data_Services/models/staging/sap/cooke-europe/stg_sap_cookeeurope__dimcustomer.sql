with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimcustomer') }}

),

renamed as (

    select

        dimcustomerid,
        vatnumber,
        customeraccountgroupname,
        vendornumber,
        foodservicesector,
        franchisorbrand,
        customercountryname,
        customerindustryname,
        language,
        street,
        customername,
        createdon,
        customernielsenid,
        tradingpartner,
        franchisorpartner,
        franchisorsector,
        customerpostalcode,
        customerindicator,
        createdby,
        l2,
        modifiedetlrunid,
        l3,
        customergroup,
        transportationzone,
        bk_customerid,
        city,
        franchise,
        subgroup,
        datasource,
        customerclassificationname,
        taxnumber2,
        customerregionname,
        taxnumber1,
        accountgroup,
        internationallocationnumber2,
        authorizationgroup,
        internationallocationnumber1,
        district,
        createdetlrunid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
