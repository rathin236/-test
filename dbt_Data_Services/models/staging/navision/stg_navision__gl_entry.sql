with source as (

    select * from {{ source('culmarex_dw_dbo', 'nav_onestream_g_l_entry') }}

),

renamed as (

    select
        id,
        business_unit_code,
        updated,
        bal__account_type,
        bill_no_,
        debit_amount,
        reversed_by_entry_no_,
        journal_batch_name,
        cod__granja,
        job_no_,
        add__currency_credit_amount,
        fa_entry_type,
        quantity,
        old_g_l_account_no_,
        source_no_,
        reversed,
        ic_partner_code,
        document_type,
        document_date,
        use_tax,
        vat_prod__posting_group,
        last_modified_datetime,
        vat_bus__posting_group,
        document_no_,
        period_trans__no_,
        system_created_entry,
        amount,
        cod__departamento,
        albaran_asociado,
        g_l_account_no_,
        global_dimension_2_code,
        external_document_no_,
        user_id,
        reversed_entry_no_,
        prior_year_entry,
        vat_amount,
        new_g_l_account_no_,
        credit_amount,
        posting_date,
        reason_code,
        additional_currency_amount,
        gen__bus__posting_group,
        gen__posting_type,
        tax_group_code,
        gen__prod__posting_group,
        description,
        tax_liable,
        description2,
        source_code,
        prod__order_no_,
        fa_entry_no_,
        company,
        add__currency_debit_amount,
        entry_no_,
        dimension_set_id,
        close_income_statement_dim__id,
        tax_area_code,
        global_dimension_1_code,
        transaction_no_,
        bal__account_no_,
        no__series,
        source_type,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
