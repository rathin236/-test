with company as (
    select
        interid as "Company",
        company_name as "Company Name",
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_d365__companies') }}

    union all

    select distinct
        upper(CompanyID) as "Company",
        upper(CompanyName) as "Company Name",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
)

select
    md5(concat(coalesce("Company", 'blank'), sourcesystem)) as sk_company_global,
    *
from company
