with gl_transactions as(

Select 

    cgt.company as company,
    cgt.transaction_status as transaction_status,
    cgt.transaction_date as transaction_date,
    cgt.period_number as period_number,
    cgt.journalentrynumber as journal_entry_no,
    cgt.account_number as account_number,
    cgt.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    cgt.cost_center as cost_center,
    cgt.department as department,
    cgt.account_description as account_description,
    cgt.accounting_currency_debit_amount as accounting_debit_amount,
    cgt.accounting_currency_credit_amount as accounting_credit_amount,
    cgt.description as description,
    cgt.originating_master_name as originating_master_name,
    cgt.originating_document_number as originating_document_number,
    cgt.originating_posting_date as originating_posting_date,
    cgt.transaction_currency as transaction_currency,
    cgt.voided as voided,
    cgt.exchange_rate as exchange_rate,
    cgt.originating_debit_amount as originating_debit_amount,
    cgt.originating_credit_amount as originating_credit_amount

from {{ref("int_cul__gl_transactions")}} cgt
left Join {{ref("stg_navision__accountschedule")}} acs
    On cgt.account_number = acs.value
    and trim(cgt.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    