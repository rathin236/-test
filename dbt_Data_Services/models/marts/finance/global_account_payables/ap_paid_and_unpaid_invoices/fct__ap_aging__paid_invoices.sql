with all_vendors as (
    select * from {{ ref('dim__vendors') }}
),

all_invoices as (
    {{ dbt_utils.union_relations(
    relations=[
      ref('fct_gp__paid_invoices'),
      ref('fct_d365__paid_invoices')
    ],
      source_column_name=None,
      exclude=['_dbt_source_relation']
  ) }}
),

paid_invoices as (
    select
        inv.company_id,
        inv.vendor_id,
        inv.document_type_id,
        inv.po_number,
        inv.company_currency,
        inv.voucher,
        inv.status,
        inv.document_number,
        inv.document_date,
        inv.gl_posting_date,
        inv.due_date,
        inv.currency_id,
        inv.functional_document_amount,
        inv.originating_document_amount,
        inv.cad_amount,
        inv.usd_amount,
        inv.cad_purchase_amount,
        inv.usd_purchase_amount,
        inv.originating_transaction_amount,
        inv.functional_transaction_amount,
        inv.sk_vendor_global,
        inv.sk_doctype_global,
        inv.sk_ap_global,
        inv.source_type,
        inv.days_to_pay,
        cast(
            case
                when trim(coalesce(inv.po_number, '')) = '' then 'Non-PO'
                else 'PO'
            end as varchar
        ) as po_type,
        case
            when inv.due_date < '2000-01-01'
                then
                    datediff(
                        day,
                        inv.gl_posting_date,
                        dateadd(day, cast(coalesce(vend.vend_terms, 0) as integer), inv.document_date)
                    )
            else
                inv.days_to_overdue
        end as days_to_overdue

    from all_invoices as inv
    left join all_vendors as vend
        on inv.sk_vendor_global = vend.sk_vendor_global
)

select * from paid_invoices
