with gl_transactions as(

Select 

    gmbs.company as company,
    gmbs.transaction_status as transaction_status,
    gmbs.transaction_date as transaction_date,
    gmbs.period_number as period_number,
    gmbs.journalentrynumber as journal_entry_no,
    gmbs.account_number as account_number,
    gmbs.natural_number as natural_number,
    acs.row_no_ as d365_account_number,
    gmbs.cost_center as cost_center,
    gmbs.department as department,
    gmbs.account_description as account_description,
    gmbs.accounting_currency_debit_amount as accounting_debit_amount,
    gmbs.accounting_currency_credit_amount as accounting_credit_amount,
    gmbs.description as description,
    gmbs.originating_master_name as originating_master_name,
    gmbs.originating_document_number as originating_document_number,
    gmbs.originating_posting_date as originating_posting_date,
    gmbs.transaction_currency as transaction_currency,
    gmbs.voided as voided,
    gmbs.exchange_rate as exchange_rate,
    gmbs.originating_debit_amount as originating_debit_amount,
    gmbs.originating_credit_amount as originating_credit_amount

from {{ref("int_gmbs__gl_transactions")}} gmbs
left Join {{ref("stg_navision__accountschedule")}} acs
    On gmbs.account_number = acs.value
    and trim(gmbs.company) = trim(acs.company)
WHERE transaction_date >= date_trunc('month', dateadd('month', -11, dateadd('year', -3, current_date)))::date
Order by transaction_date

)

Select * from gl_transactions    