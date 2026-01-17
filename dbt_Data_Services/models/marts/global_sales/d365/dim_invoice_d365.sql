with invent_trans as (
    select * from {{ ref('stg_d365__invent_trans') }}
),

dim_invoice as (
    select invoiceid as "Invoice ID" from invent_trans

    qualify row_number() over (partition by invoiceid order by invoiceid) = 1

    order by "Invoice ID"
)

select * from dim_invoice
