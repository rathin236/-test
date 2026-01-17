with gl_transactions as(

   Select 

    bgps.company as company,
    bgps.transaction_status as transaction_status,
    bgps.transaction_date as transaction_date,
    bgps.period_number as period_number,
    bgps.journalentrynumber as journal_entry_no,
    bgps.account_number as account_number,
    bgps.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    bgps.cost_center as cost_center,
    bgps.department as department,
    bgps.account_description as account_description,
    bgps.accounting_currency_debit_amount as accounting_debit_amount,
    bgps.accounting_currency_credit_amount as accounting_credit_amount,
    bgps.description as description,
    bgps.originating_master_name as originating_master_name,
    bgps.originating_document_number as originating_document_number,
    bgps.originating_posting_date as originating_posting_date,
    bgps.transaction_currency as transaction_currency,
    bgps.voided as voided,
    bgps.exchange_rate as exchange_rate,
    bgps.originating_debit_amount as originating_debit_amount,
    bgps.originating_credit_amount as originating_credit_amount

from {{ref("int_bgps__gl_transactions")}} bgps
left Join {{ref("stg_navision__accountschedule")}} acs
    On bgps.account_number = acs.value
    and trim(bgps.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date    
Order by transaction_date

)

Select * from gl_transactions    
