with paid_invoices as (
    select
        transaction_id,
        company_id,
        vendor_id,
        document_type_id,
        currency_id,
        voucher,
        bach_number,
        payment_terms as pymtrmid,
        userid,
        document_number,
        document_date,
        gl_posting_date,
        due_date,
        pm_po_number as po_number,
        company_currency,
        functional_document_amount,
        functional_transaction_amount,
        converted_originating_doc_amount as originating_document_amount,
        converted_originating_trans_amount as originating_transaction_amount,
        cad_amount,
        usd_amount,
        cad_purchase_amount,
        usd_purchase_amount,
        days_to_pay,
        days_to_overdue,
        sk_vendor_global,
        sk_doctype_global,
        status,
        'GP' as source_type,
        md5(
            concat_ws(
                '||',
                coalesce(sk_vendor_global, ''),
                coalesce(to_char(transaction_id), ''),
                coalesce(to_char(document_type_id), ''),
                coalesce(to_char(voucher), ''),
                coalesce(to_char(document_number), ''),
                coalesce(to_char(document_date), '')
            )
        ) as sk_ap_global
    from {{ ref('int_global_ap__gp__paid_invoices') }}
)

select * from paid_invoices
