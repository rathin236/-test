with erpx_mf_data_entity_company as (
    select * from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
),

tn_fresh_dim_processing_company as (
    select

        companyid as "CompanyCode",
        companyname as "CompanyName",
        servername as "HostServer",
        databasename as "DBName",

        -- These are Key references that can be used to join between other dimensions
        'NS_' || dataentitycompanysk as "Key_Company"

    from erpx_mf_data_entity_company
)

select * from tn_fresh_dim_processing_company
