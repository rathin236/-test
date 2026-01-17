with d365product as (
    select * from {{ ref ('int_d365_crm__d365product') }}
),

crmproduct as (
    select * from {{ ref ('int_d365_crm__crmproduct') }}
),

importdata as ( --cte to compare d365product against crmproduct, and flag the records that needs to be created as new or updated
    select * from {{ ref('int_d365_crm__importdata_products') }}
),

alldata as (
    select
        status,
        source,
        company,
        productstructure,
        producttype,
        productid,
        productdesc,
        unitgroup,
        unit,
        gpproductid,
        d365productid,
        crmproductid,
        uomscheduleid,
        uomid,
        companyid,
        statusuid,
        parentproductid_value
    from d365product
    union all
    select
        status,
        source,
        company,
        productstructure,
        producttype,
        productid,
        productdesc,
        unitgroup,
        unit,
        gpproductid,
        d365productid,
        crmproductid,
        uomscheduleid,
        uomid,
        companyid,
        statusuid,
        parentproductid_value
    from crmproduct
    union all
    select
        status,
        source,
        company,
        productstructure,
        producttype,
        productid,
        productdesc,
        unitgroup,
        unit,
        gpproductid,
        d365productid,
        crmproductid,
        uomscheduleid,
        uomid,
        companyid,
        statusuid,
        parentproductid_value
    from importdata
)

select * from alldata
order by productid
