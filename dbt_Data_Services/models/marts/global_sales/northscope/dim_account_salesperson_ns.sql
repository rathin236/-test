with int_ns_account_salesperson as (
    select * from {{ ref('int_global_sales__dim_account_salesperson_northscope') }}
),

ns_account_salesperson as (
    select

        invoicecustomer_number,
        salespersons_name,
        create_date,
        sourcesystem,
        flag_most_recent

    from int_ns_account_salesperson

    where flag_most_recent = 1
)

select * from ns_account_salesperson
