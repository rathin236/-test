with gl_transactions as(

Select 

    bsslu.company as company,
    bsslu.transaction_status as transaction_status,
    bsslu.transaction_date as transaction_date,
    bsslu.period_number as period_number,
    bsslu.journalentrynumber as journal_entry_no,
    bsslu.account_number as account_number,
    bsslu.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    bsslu.cost_center as cost_center,
    bsslu.department as department,
    bsslu.account_description as account_description,
    bsslu.accounting_currency_debit_amount as accounting_debit_amount,
    bsslu.accounting_currency_credit_amount as accounting_credit_amount,
    bsslu.description as description,
    bsslu.originating_master_name as originating_master_name,
    bsslu.originating_document_number as originating_document_number,
    bsslu.originating_posting_date as originating_posting_date,
    bsslu.transaction_currency as transaction_currency,
    bsslu.voided as voided,
    bsslu.exchange_rate as exchange_rate,
    bsslu.originating_debit_amount as originating_debit_amount,
    bsslu.originating_credit_amount as originating_credit_amount

from {{ref("int_bsslu__gl_transactions")}} bsslu
left Join {{ref("stg_navision__accountschedule")}} acs
    On bsslu.account_number = acs.value
    and trim(bsslu.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    