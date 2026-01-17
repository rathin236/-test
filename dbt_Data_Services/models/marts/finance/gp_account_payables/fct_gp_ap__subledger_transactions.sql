-- models/marts/finance/fct_ap_subledger_transactions.sql
{{ config(materialized='table') }}

with vend_open as (
    select
        company_id,
        company_currency,
        vendor_class_id,
        vendor_id,
        vendor_name,
        payment_terms,
        document_date,
        due_date,
        document_number,
        currency_id,
        voucher,
        originating_document_amount,
        originating_check_total,
        originating_applied_amount,
        functional_document_amount,
        functional_transaction_amount,
        exchange_rate,
        exchange_table_id,
        originating_currency,
        rate_type_id,
        status,
        document_type_id,
        document_type_desc,
        bach_number,
        bach_source,
        posting_date,
        voided_date,
        voided,
        description,
        checkbook_id,
        pm_po_number,
        pm_po_number_alt
    from {{ ref('int_global_ap__gp__open_invoices') }}
),

--Paid
vend_hist as (
    select
        company_id,
        company_currency,
        vendor_class_id,
        vendor_id,
        vendor_name,
        payment_terms,
        document_date,
        due_date,
        document_number,
        currency_id,
        voucher,
        originating_document_amount,
        originating_check_total,
        originating_applied_amount,
        functional_document_amount,
        functional_transaction_amount,
        exchange_rate,
        exchange_table_id,
        originating_currency,
        rate_type_id,
        status,
        document_type_id,
        document_type_desc,
        bach_number,
        bach_source,
        posting_date,
        voided_date,
        voided,
        description,
        checkbook_id,
        pm_po_number,
        pm_po_number_alt
    from {{ ref('int_global_ap__gp__paid_invoices') }}
),

final as (
    select * from vend_open
    union
    select * from vend_hist
)

select *
from final
/*
where document_date is null
   or document_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date())))
*/
