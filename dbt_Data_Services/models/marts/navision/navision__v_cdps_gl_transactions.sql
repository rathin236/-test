with gl_transactions as(

Select 

    cdps.company as company,
    cdps.transaction_status as transaction_status,
    cdps.transaction_date as transaction_date,
    cdps.period_number as period_number,
    cdps.journalentrynumber as journal_entry_no,
    cdps.account_number as account_number,
    cdps.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    cdps.cost_center as cost_center,
    cdps.department as department,
    cdps.account_description as account_description,
    cdps.accounting_currency_debit_amount as accounting_debit_amount,
    cdps.accounting_currency_credit_amount as accounting_credit_amount,
    cdps.description as description,
    cdps.originating_master_name as originating_master_name,
    cdps.originating_document_number as originating_document_number,
    cdps.originating_posting_date as originating_posting_date,
    cdps.transaction_currency as transaction_currency,
    cdps.voided as voided,
    cdps.exchange_rate as exchange_rate,
    cdps.originating_debit_amount as originating_debit_amount,
    cdps.originating_credit_amount as originating_credit_amount

from {{ref("int_cdps__gl_transactions")}} cdps
left Join {{ref("stg_navision__accountschedule")}} acs
    On cdps.account_number = acs.value
    and trim(cdps.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    