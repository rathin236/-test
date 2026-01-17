with companies as (
    select * from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
),

dim_company as (
    select

        dataentitycompanysk as "Data_Entity_Company_SK",
        companyid as "Company ID",
        companyname as "Company Name"

    from companies

    qualify row_number() over (partition by dataentitycompanysk order by dataentitycompanysk) = 1

    order by dataentitycompanysk
)

select * from dim_company
