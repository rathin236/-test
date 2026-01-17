with gl_transactions as(

Select 

    basa.company as company,
    basa.transaction_status as transaction_status,
    basa.transaction_date as transaction_date,
    basa.period_number as period_number,
    basa.journalentrynumber as journal_entry_no,
    basa.account_number as account_number,
    basa.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    basa.cost_center as cost_center,
    basa.department as department,
    basa.account_description as account_description,
    basa.accounting_currency_debit_amount as accounting_debit_amount,
    basa.accounting_currency_credit_amount as accounting_credit_amount,
    basa.description as description,
    basa.originating_master_name as originating_master_name,
    basa.originating_document_number as originating_document_number,
    basa.originating_posting_date as originating_posting_date,
    basa.transaction_currency as transaction_currency,
    basa.voided as voided,
    basa.exchange_rate as exchange_rate,
    basa.originating_debit_amount as originating_debit_amount,
    basa.originating_credit_amount as originating_credit_amount

from {{ref("int_basa__gl_transactions")}} basa
left Join {{ref("stg_navision__accountschedule")}} acs
    On basa.account_number = acs.value
    and trim(basa.company) = trim(acs.company)
WHERE basa.transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions
