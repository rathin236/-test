with gl_transactions as(

Select 

    ls.company as company,
    ls.transaction_status as transaction_status,
    ls.transaction_date as transaction_date,
    ls.period_number as period_number,
    ls.journalentrynumber as journal_entry_no,
    ls.account_number as account_number,
    ls.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    ls.cost_center as cost_center,
    ls.department as department,
    ls.account_description as account_description,
    ls.accounting_currency_debit_amount as accounting_debit_amount,
    ls.accounting_currency_credit_amount as accounting_credit_amount,
    ls.description as description,
    ls.originating_master_name as originating_master_name,
    ls.originating_document_number as originating_document_number,
    ls.originating_posting_date as originating_posting_date,
    ls.transaction_currency as transaction_currency,
    ls.voided as voided,
    ls.exchange_rate as exchange_rate,
    ls.originating_debit_amount as originating_debit_amount,
    ls.originating_credit_amount as originating_credit_amount

from {{ref("int_ls__gl_transactions")}} ls
left Join {{ref("stg_navision__accountschedule")}} acs
    On ls.account_number = acs.value
    and trim(ls.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    