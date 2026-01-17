with d365uom as ( --cte to get all d365 units and unit conversions
    select * from {{ ref('int_d365_crm__d365uom') }}
),

crmuom as ( --cte to get all crm active/under revision products
    select * from {{ ref('int_d365_crm__crmuom') }}
),

importdata as ( --cte to compare d365 uom agains crm uom, and flag the records that needs to be created as new. no need for update.
    select * from {{ ref('int_d365_crm__importdata_unit_groups') }}
),

alldata as (
    select
        status,
        source,
        coalesce(productid, '') as productid,
        baseunitname,
        description,
        uomscheduleid,
        uomid,
        company,
        unitgroupname
    from d365uom
    union
    select
        status,
        source,
        coalesce(productid, '') as productid,
        baseunitname,
        description,
        uomscheduleid,
        uomid,
        company,
        unitgroupname
    from crmuom
    union
    select
        status,
        source,
        coalesce(productid, '') as productid,
        baseunitname,
        description,
        uomscheduleid,
        uomid,
        company,
        unitgroupname
    from importdata
)

select * from alldata
