with bsslu_transactions as (

    select
        company,
        transaction_status,
        transaction_date,
        period_number,
        journal_entry_no as journalentrynumber,
        account_number,
        natural_number,
        cost_center,
        department,
        account_description,
        cost_center_description,
        department_description,
        reference_text,
        originating_master_name,
        originating_master_id,
        originating_document_number,
        originating_posting_date,
        transaction_currency,
        exchange_rate,
        description,
        voided,
        round(accounting_currency_debit_amount, 2) as accounting_currency_debit_amount,
        round(accounting_currency_credit_amount, 2) as accounting_currency_credit_amount,
        round(originating_debit_amount, 2) as originating_debit_amount,
        round(originating_credit_amount, 2) as originating_credit_amount

    from {{ ref('stg_navision__gl_transactions') }}
    where company = 'BERSOLAZ SPAIN S_L_U_'
)

select * from bsslu_transactions
