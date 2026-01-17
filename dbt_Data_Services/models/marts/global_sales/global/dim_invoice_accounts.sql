with invoice as (
    select
        null as "Invoice_ID_SK",
        *,
        case
            when "Customer Name" in (
                    'A. C. Covert', 'Wanchese Europe', 'A.C. Covert Distributors (TNS)',
                    'T N Salmon Ltd Partnership (Organic)',
                    'True North Seafood New Bedford', 'Wanchese Fish Company, Inc.',
                    'TRUE NORTH SEAFOOD INC', 'T N Salmon Ltd Partnership', 'True North Seafood, Inc.',
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
        end as "Invoicing Customer Type",
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_invoice_accounts_d365') }}

    union all

    select
        *,
        case
            when "Customer Name" in (
                    'A. C. Covert', 'Wanchese Europe', 'A.C. Covert Distributors (TNS)',
                    'T N Salmon Ltd Partnership (Organic)',
                    'True North Seafood New Bedford', 'Wanchese Fish Company, Inc.',
                    'TRUE NORTH SEAFOOD INC', 'T N Salmon Ltd Partnership',
                    'True North Seafood, Inc.',
                    'True North Salmon Limited Partnership (USD)',
                    'True North Salmon Limited Partnership', 'True North Salmon Inventory',
                    'Wanchese Fish Company Inc.', 'AC Covert (Sysco Atlantic Sales)',
                    'True North Seafood Inventory', 'True North Seafood Inc',
                    'The Fish Company Inc', 'True North Seafood Company',
                    'True North Salmon Inventory-Maine',
                    'The Fish Company Inc.', 'AC Covert Distributors',
                    'A.C. Covert Retail Store'
                )
                then 'Intercompany'
            else 'External'
        end as "Invoicing Customer Type",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_invoice_accounts_ns') }}
),

invoice_accounts as (
    select
        md5(concat(coalesce("Invoice_ID_SK", "Invoice ID"), sourcesystem)) as sk_invoice_account_global,
        "Invoice ID",
        "Invoice_ID_SK",
        "Customer Name" as "Invoicing Customer Name",
        "Customer Business Type",
        "Location",
        "Location Name",
        "Address",
        "Street",
        "City",
        "Zip Code",
        "State",
        "Country",
        "Longitude",
        "Latitude",
        "Valid From",
        "Valid To",
        sourcesystem,
        sourcesystemcode
    from invoice
)

select * from invoice_accounts
