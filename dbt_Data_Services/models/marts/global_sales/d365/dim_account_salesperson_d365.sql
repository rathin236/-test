with int_d365_account_salesperson as (
    select * from {{ ref('int_global_sales__d365_account_salesperson') }}
),

d365_account_salesperson as (
    select

        invoicecustomer_number,
        salespersons_name as "Salespersons Name",
        create_date as "Create Date",
        sourcesystem,
        flag_most_recent

    from int_d365_account_salesperson

    where flag_most_recent = 1
)

select * from d365_account_salesperson
-- where salespersons_name like '%Bryan%'