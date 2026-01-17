with unpaid_invoices as (
    select *
    from {{ ref('fct__open_ap_transactions') }}
),

final_result as (
    select
        unpaid_invoices.company_id,
        unpaid_invoices.vendor_id,
        unpaid_invoices.document_type_id,
        unpaid_invoices.po_number,
        unpaid_invoices.company_currency,
        unpaid_invoices.voucher,
        unpaid_invoices.status,
        unpaid_invoices.document_number,
        unpaid_invoices.document_date,
        unpaid_invoices.gl_posting_date,
        unpaid_invoices.due_date,
        unpaid_invoices.currency_id,
        unpaid_invoices.functional_document_amount,
        unpaid_invoices.originating_document_amount,
        unpaid_invoices.cad_amount,
        unpaid_invoices.usd_amount,
        unpaid_invoices.cad_purchase_amount,
        unpaid_invoices.usd_purchase_amount,
        unpaid_invoices.originating_transaction_amount,
        unpaid_invoices.functional_transaction_amount,
        unpaid_invoices.sk_vendor_global,
        unpaid_invoices.sk_doctype_global,
        unpaid_invoices.source_type,
        null as days_to_pay,
        cast(
            case
                when trim(coalesce(unpaid_invoices.po_number, '')) = '' then 'Non-PO'
                else 'PO'
            end as varchar
        ) as po_type,
        (unpaid_invoices.due_date - current_date) as days_to_overdue,
        md5(
            concat_ws(
                '||',
                coalesce(unpaid_invoices.sk_vendor_global, ''),
                coalesce(to_char(unpaid_invoices.transaction_id), ''),
                coalesce(to_char(unpaid_invoices.document_type_id), ''),
                coalesce(to_char(unpaid_invoices.voucher), ''),
                coalesce(to_char(unpaid_invoices.document_number), ''),
                coalesce(to_char(unpaid_invoices.document_date), '')
            )
        ) as sk_ap_global
    from unpaid_invoices as unpaid_invoices
)

select *
from final_result
