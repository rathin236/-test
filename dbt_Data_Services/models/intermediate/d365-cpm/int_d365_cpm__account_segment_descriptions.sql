with davc as (
    select
        recid,
        mainaccountvalue,
        costcentervalue,
        departmentvalue,
        divisionvalue,
        locationvalue,
        productlinevalue,
        cashflowtypevalue,
        companyrelationshipvalue,
        mainaccount,
        costcenter,
        department,
        division,
        location,
        productline,
        cashflowtype,
        companyrelationship
    from {{ ref('stg_d365__dimension_attribute_value_combination') }}
),

mac as (
    select
        recid,
        name
    from {{ ref('stg_d365__main_account') }}
),

ccd as (
    select
        recid,
        description
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

depd as (
    select
        recid,
        name
    from {{ ref('int_d365__dim_attribute_om_department') }}
),

divd as (
    select
        recid,
        name
    from {{ ref('int_d365__dim_attribute_om_business_unit') }}
),

locd as (
    select
        recid,
        description
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

pld as (
    select
        recid,
        description
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

cfd as (
    select
        recid,
        description
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

crd as (
    select
        recid,
        description
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

final as (
    select
        davc.recid,
        davc.mainaccountvalue,
        davc.costcentervalue,
        davc.departmentvalue,
        davc.divisionvalue,
        davc.locationvalue,
        davc.productlinevalue,
        davc.cashflowtypevalue,
        davc.companyrelationshipvalue,
        mac.name as mainaccountdescription,
        ccd.description as costcenterdescription,
        depd.name as departmentdescription,
        divd.name as divisiondescription,
        locd.description as locationdescription,
        pld.description as productlinedescription,
        cfd.description as cashflowdescription,
        crd.description as companyrelationshipdescription
    from davc
    left outer join mac
        on davc.mainaccount = mac.recid
    left outer join ccd
        on davc.costcenter = ccd.recid
    left outer join depd
        on davc.department = depd.recid
    left outer join divd
        on davc.division = divd.recid
    left outer join locd
        on davc.location = locd.recid
    left outer join pld
        on davc.productline = pld.recid
    left outer join cfd
        on davc.cashflowtype = cfd.recid
    left outer join crd
        on davc.companyrelationship = crd.recid
)

select * from final
