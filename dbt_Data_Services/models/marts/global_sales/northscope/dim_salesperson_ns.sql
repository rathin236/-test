with erpx_so_salesperson as (
    select * from {{ ref('stg_northscope__erpx_so_salesperson') }}
),

dim_salesperson as (
    select

        salespersonsk as "Salesperson_SK",
        salespersonid as "Salesperson ID",
        salespersonname as "Salesperson Name",
        email as "Email",
        isinactive as "Is Inactive",
        dataentitycompanysk as "Data_Entity_Company_SK",
        salespersontypeen

    from erpx_so_salesperson

    qualify row_number() over (partition by salespersonsk order by salespersonsk) = 1

    order by salespersonsk

)

select * from dim_salesperson
