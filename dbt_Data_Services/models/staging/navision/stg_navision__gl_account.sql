with source as (

    select * from {{ source('culmarex_dw_dbo', 'nav_onestream_g_l_account') }}

),

renamed as (

    select
        id,
        tax_area_code,
        cost_type_no_,
        income_stmt__bal__acc_,
        company,
        indentation,
        id_company,
        consol__credit_acc_,
        account_category,
        debit_credit,
        direct_posting,
        no_,
        account_subcategory_entry_no_,
        picture,
        name,
        reconciliation_account,
        tax_group_code,
        global_dimension_1_code,
        no__of_blank_lines,
        vat_bus__posting_group,
        omit_default_descr__in_jnl_,
        global_dimension_2_code,
        automatic_ext__texts,
        consol__debit_acc_,
        consol__translation_method,
        cuenta_irpf,
        account_type,
        new_page,
        gen__prod__posting_group,
        vat_prod__posting_group,
        default_deferral_template_code,
        search_name,
        income_balance,
        gen__bus__posting_group,
        exchange_rate_adjustment,
        ignore_in_347_report,
        default_ic_partner_g_l_acc__no,
        ignore_discounts,
        tax_liable,
        blocked,
        last_date_modified,
        gen__posting_type,
        totaling,
        id_nav,
        no__2,
        last_modified_date_time,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
