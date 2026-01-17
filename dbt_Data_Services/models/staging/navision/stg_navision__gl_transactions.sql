with source as (

    select * from {{ source('culmarex_dw_dbo', 'nav_onestream') }}

),

renamed as (

    select
        id,
        originating_credit_amount,
        originating_debit_amount,
        originating_master_id,
        transaction_currency,
        department_description,
        voided,
        account_number,
        reference_text,
        cost_center,
        account_description,
        natural_number,
        originating_master_name,
        cost_center_description,
        transaction_status,
        journal_entry_no,
        accounting_currency_debit_amount,
        accounting_currency_credit_amount,
        originating_document_number,
        originating_posting_date,
        transaction_date,
        period_number,
        company,
        exchange_rate,
        description,
        department,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
