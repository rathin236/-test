with

source as (

    select {{ convert_columns('finops_synapse', 'dimensionattributevalueset') }}
    from {{ source('finops_synapse', 'dimensionattributevalueset') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        hashversion,
        sysdatastatecode,
        implieddataareaid,
        mainaccount,
        mainaccountvalue,
        systemgeneratedattributebankaccount,
        systemgeneratedattributebankaccountvalue,
        systemgeneratedattributecustomer,
        systemgeneratedattributecustomervalue,
        systemgeneratedattributeemployee,
        systemgeneratedattributeemployeevalue,
        systemgeneratedattributefixedasset,
        systemgeneratedattributefixedassetvalue,
        systemgeneratedattributeitem,
        systemgeneratedattributeitemvalue,
        systemgeneratedattributeproject,
        systemgeneratedattributeprojectvalue,
        systemgeneratedattributevendor,
        systemgeneratedattributevendorvalue,
        systemgeneratedattributefixedassets_ru,
        systemgeneratedattributefixedassets_ruvalue,
        systemgeneratedattributerdeferrals,
        systemgeneratedattributerdeferralsvalue,
        systemgeneratedattributercash,
        systemgeneratedattributercashvalue,
        systemgeneratedattributeemployee_ru,
        systemgeneratedattributeemployee_ruvalue,
        division,
        divisionvalue,
        location,
        locationvalue,
        productline,
        productlinevalue,
        companyrelationship,
        companyrelationshipvalue,
        costcenter,
        costcentervalue,
        cashflowtype,
        cashflowtypevalue,
        department,
        departmentvalue,
        to_delete_2,
        to_delete_2_value,
        to_delete_1,
        to_delete_1_value,
        modifieddatetime,
        modifiedby,
        modifiedtransactionid,
        createddatetime,
        createdby,
        createdtransactionid,
        dataareaid,
        recversion,
        partition,
        sysrowversion,
        recid,
        tableid,
        versionnumber,
        createdon,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
