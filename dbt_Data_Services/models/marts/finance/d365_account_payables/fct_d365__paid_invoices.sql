select
    *,
    'D365' as source_type,
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
from {{ ref('int_global_ap__d365_tnsf_paid_invoices') }}
