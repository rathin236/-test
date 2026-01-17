-- models/marts/finance/fct_ar_subledger_transactions.sql
{{ config(materialized='table') }}

with cust_open as (
    select
        transaction_id,
        company_id,
        customer_id,
        document_type_id,
        document_type_desc,
        company_currency,
        customer_class_id,
        customer_name,
        payment_terms,
        credit_limit_type,
        customer_credit_limit,
        currency_id,
        bach_number,
        document_number,
        document_date,
        gl_posting_date,
        due_date,
        voided_date,
        voided,
        description,
        exchange_rate,
        exchange_table_id,
        originating_currency,
        rate_type_id,
        originating_sales_amount,
        originating_transaction_amount,
        or_originating_transaction,
        functional_current_transaction_amount,
        functional_originating_transaction_amount
    from {{ ref('int_global_ar__gp__open_documents') }}
),

cust_hist as (
    select
        transaction_id,
        company_id,
        customer_id,
        document_type_id,
        document_type_desc,
        company_currency,
        customer_class_id,
        customer_name,
        payment_terms,
        credit_limit_type,
        customer_credit_limit,
        currency_id,
        bach_number,
        document_number,
        document_date,
        gl_posting_date,
        due_date,
        voided_date,
        voided,
        description,
        exchange_rate,
        exchange_table_id,
        originating_currency,
        rate_type_id,
        originating_sales_amount,
        originating_transaction_amount,
        or_originating_transaction,
        functional_current_transaction_amount,
        functional_originating_transaction_amount
    from {{ ref('int_global_ar__gp__paid_documents') }}
),

final as (
    select * from cust_open
    union all
    select * from cust_hist
)

select *
from final
