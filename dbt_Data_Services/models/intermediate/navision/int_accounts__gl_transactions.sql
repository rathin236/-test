with accountschedule as (
    select * from {{ ref('stg_navision__accountschedule') }}
),

gl_account as (
    select * from {{ ref('stg_navision__gl_account') }}
),

cul_gl_transactions as (
    select * from {{ ref('int_cul__gl_transactions') }}
),

final as (
    select
        cgt.company,
        cgt.transaction_status,
        cgt.transaction_date,
        cgt.period_number,
        cgt.journalentrynumber as journal_entry_no,
        cgt.account_number,
        cgt.natural_number,
        acs.row_no_ as d365_account_number,
        cgt.cost_center,
        cgt.department,
        cgt.account_description,
        cgt.accounting_currency_debit_amount as accounting_debit_amount,
        cgt.accounting_currency_credit_amount as accounting_credit_amount,
        cgt.description,
        cgt.originating_master_name,
        cgt.originating_document_number,
        cgt.originating_posting_date,
        cgt.transaction_currency,
        cgt.voided,
        cgt.exchange_rate,
        cgt.originating_debit_amount,
        cgt.originating_credit_amount
    from accountschedule as acs
    inner join gl_account as gla
    on acs.company = gla.company and acs.value = gla.no_
    left join cul_gl_transactions as cgt
    on acs.company = cgt.company --and acs.value = cgt.account_number
)

select * from final
