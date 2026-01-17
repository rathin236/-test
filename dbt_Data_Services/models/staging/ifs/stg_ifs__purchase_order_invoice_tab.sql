with source as (

    select * from {{ source('ifs_prod_omeg1app', 'purchase_order_invoice_tab') }}

),

renamed as (

    select
        ap_invoice_no,
        invoice_company,
        invoice_id,
        line_no,
        order_no,
        receipt_no,
        release_no,
        series_id,
        msg_version_no,
        date_entered,
        price_unit_meas,
        part_no,
        price_difference,
        contract,
        currency_code,
        currency_rate,
        unit_meas,
        unit_price_diff,
        matching_date,
        rowversion,
        invoicing_supplier,
        unit_price_paid,
        fee_code,
        last_inv_line_total,
        msg_sequence_no,
        conv_factor,
        qty_invoiced,
        price_conv_factor,
        advice_id,
        purchase_matching_type,
        rowkey,
        additional_cost,
        discount,
        funit_price_diff,
        last_inv_buy_qty_due,
        buy_unit_meas,
        matched_by_user,
        transaction_reval_executed,
        funit_price_paid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
