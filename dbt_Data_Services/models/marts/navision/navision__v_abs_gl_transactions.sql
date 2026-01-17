with gl_transactions as(

Select 

    aqbs.company as company,
    aqbs.transaction_status as transaction_status,
    aqbs.transaction_date as transaction_date,
    aqbs.period_number as period_number,
    aqbs.journalentrynumber as journal_entry_no,
    aqbs.account_number as account_number,
    aqbs.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    aqbs.cost_center as cost_center,
    aqbs.department as department,
    aqbs.account_description as account_description,
    aqbs.accounting_currency_debit_amount as accounting_debit_amount,
    aqbs.accounting_currency_credit_amount as accounting_credit_amount,
    aqbs.description as description,
    aqbs.originating_master_name as originating_master_name,
    aqbs.originating_document_number as originating_document_number,
    aqbs.originating_posting_date as originating_posting_date,
    aqbs.transaction_currency as transaction_currency,
    aqbs.voided as voided,
    aqbs.exchange_rate as exchange_rate,
    aqbs.originating_debit_amount as originating_debit_amount,
    aqbs.originating_credit_amount as originating_credit_amount

from {{ref("int_abs__gl_transactions")}} aqbs
left Join {{ref("stg_navision__accountschedule")}} acs
    On aqbs.account_number = acs.value
    and trim(aqbs.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date    

)

Select * from gl_transactions    
