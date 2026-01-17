with customer_d365 as (
    select
        *,
        case
            when "Customer Name" in (
                    'A. C. Covert', 'Wanchese Europe', 'A.C. Covert Distributors (TNS)',
                    'T N Salmon Ltd Partnership (Organic)', 'True North Seafood New Bedford',
                    'Wanchese Fish Company, Inc.', 'TRUE NORTH SEAFOOD INC',
                    'T N Salmon Ltd Partnership', 'True North Seafood, Inc.',
                    'True North Salmon Limited Partnership (USD)',
                    'True North Salmon Limited Partnership', 'True North Salmon Inventory',
                    'Wanchese Fish Company Inc.', 'AC Covert (Sysco Atlantic Sales)',
                    'True North Seafood Inventory', 'True North Seafood Inc',
                    'The Fish Company Inc', 'True North Seafood Company',
                    'True North Salmon Inventory-Maine', 'The Fish Company Inc.',
                    'AC Covert Distributors', 'A.C. Covert Retail Store'
                )
                then 'Intercompany'
            else 'External'
        end as "Customer Type",
        'D365' as sourcesystem,
        0 as sourcesystemcode,
        row_number() over (partition by "Customer ID" order by "Customer ID") as row_number
    from {{ ref('dim_customer_accounts_d365') }}
),

customer_ns as (
    select
        *,
        case
            when "Customer Name" in (
                    'A. C. Covert', 'Wanchese Europe', 'A.C. Covert Distributors (TNS)',
                    'T N Salmon Ltd Partnership (Organic)', 'True North Seafood New Bedford',
                    'Wanchese Fish Company, Inc.', 'TRUE NORTH SEAFOOD INC',
                    'T N Salmon Ltd Partnership', 'True North Seafood, Inc.',
                    'True North Salmon Limited Partnership (USD)',
                    'True North Salmon Limited Partnership', 'True North Salmon Inventory',
                    'Wanchese Fish Company Inc.', 'AC Covert (Sysco Atlantic Sales)',
                    'True North Seafood Inventory', 'True North Seafood Inc',
                    'The Fish Company Inc', 'True North Seafood Company',
                    'True North Salmon Inventory-Maine', 'The Fish Company Inc.',
                    'AC Covert Distributors', 'A.C. Covert Retail Store'
                )
                then 'Intercompany'
            else 'External'
        end as "Customer Type",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        row_number() over (partition by "Customer_Address_SK" order by "Customer_Address_SK") as row_number
    from {{ ref('dim_customer_accounts_ns') }}

),

customer as (
    select * from customer_d365
    where row_number = 1

    union all

    select * from customer_ns
    where row_number = 1
)

select
    md5(concat(coalesce("Customer_Address_SK", "Customer ID"), sourcesystem)) as sk_customer_id_global,
    md5(concat("Customer ID", sourcesystem)) as sk_customer_id_targets,
    *
from customer
