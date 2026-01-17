with gl_transactions as(

Select 

    prs.company as company,
    prs.transaction_status as transaction_status,
    prs.transaction_date as transaction_date,
    prs.period_number as period_number,
    prs.journalentrynumber as journal_entry_no,
    prs.account_number as account_number,
    prs.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    prs.cost_center as cost_center,
    prs.department as department,
    prs.account_description as account_description,
    prs.accounting_currency_debit_amount as accounting_debit_amount,
    prs.accounting_currency_credit_amount as accounting_credit_amount,
    prs.description as description,
    prs.originating_master_name as originating_master_name,
    prs.originating_document_number as originating_document_number,
    prs.originating_posting_date as originating_posting_date,
    prs.transaction_currency as transaction_currency,
    prs.voided as voided,
    prs.exchange_rate as exchange_rate,
    prs.originating_debit_amount as originating_debit_amount,
    prs.originating_credit_amount as originating_credit_amount

from {{ref("int_prs__gl_transactions")}} prs
left Join {{ref("stg_navision__accountschedule")}} acs
    On prs.account_number = acs.value
    and trim(prs.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    