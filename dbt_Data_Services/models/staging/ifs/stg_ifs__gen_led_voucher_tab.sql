with source as (

    select * from {{ source('ifs_prod_omeg1app', 'gen_led_voucher_tab') }}

),

renamed as (

    select
        accounting_year,
        company,
        voucher_no,
        voucher_type,
        voucher_text,
        entered_by_user_group,
        user_group,
        voucher_date,
        simulation_voucher,
        rowversion,
        accounting_period,
        userid,
        multi_company_id,
        status_cancelled,
        approval_date,
        accounting_text_id,
        internal_seq_number,
        vou_text_udpdated,
        approved_by_userid,
        rowkey,
        voucher_no_reference,
        voucher_type_reference,
        text_id_,
        approved_by_user_group,
        function_group,
        accounting_year_reference,
        date_reg,
        transfer_id,
        jou_no,
        voucher_text2,
        transferred,
        interim_voucher,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
