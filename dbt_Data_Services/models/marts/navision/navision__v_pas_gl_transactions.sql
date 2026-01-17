with gl_transactions as(

Select 

    pas.company as company,
    pas.transaction_status as transaction_status,
    pas.transaction_date as transaction_date,
    pas.period_number as period_number,
    pas.journalentrynumber as journal_entry_no,
    pas.account_number as account_number,
    pas.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    pas.cost_center as cost_center,
    pas.department as department,
    pas.account_description as account_description,
    pas.accounting_currency_debit_amount as accounting_debit_amount,
    pas.accounting_currency_credit_amount as accounting_credit_amount,
    pas.description as description,
    pas.originating_master_name as originating_master_name,
    pas.originating_document_number as originating_document_number,
    pas.originating_posting_date as originating_posting_date,
    pas.transaction_currency as transaction_currency,
    pas.voided as voided,
    pas.exchange_rate as exchange_rate,
    pas.originating_debit_amount as originating_debit_amount,
    pas.originating_credit_amount as originating_credit_amount

from {{ref("int_pas__gl_transactions")}} pas
left Join {{ref("stg_navision__accountschedule")}} acs
    On pas.account_number = acs.value
    and trim(pas.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    