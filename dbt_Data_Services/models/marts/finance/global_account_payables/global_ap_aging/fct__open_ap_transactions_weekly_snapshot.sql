{{
    config(
        materialized = 'incremental',
        unique_key = ['sk_ap_global', 'snapshot_week'],
        on_schema_change = 'sync_all_columns'
    )
}}

with base_ap_data as (
    select
        transaction_id,
        company_id,
        vendor_id,
        document_type_id,
        currency_id,
        voucher,
        bach_number,
        pymtrmid,
        userid,
        document_number,
        document_date,
        gl_posting_date,
        due_date,
        company_currency,
        functional_document_amount,
        functional_transaction_amount,
        originating_document_amount,
        originating_transaction_amount,
        cad_amount,
        usd_amount,
        current_amount_due_dt,
        "1_to_15_days_amount_due_dt",
        "16_to_30_days_amount_due_dt",
        "31_to_60_days_amount_due_dt",
        "61_to_90_days_amount_due_dt",
        "91_and_over_amount_due_dt",
        current_amount_doc_dt,
        "1_to_15_days_amount_doc_dt",
        "16_to_30_days_amount_doc_dt",
        "31_to_60_days_amount_doc_dt",
        "61_to_90_days_amount_doc_dt",
        "91_and_over_amount_doc_dt",
        current_org_amt_due_dt,
        "1_to_15_days_org_amt_due_dt",
        "16_to_30_days_org_amt_due_dt",
        "31_to_60_days_org_amt_due_dt",
        "61_to_90_days_org_amt_due_dt",
        "91_and_over_org_amt_due_dt",
        current_org_amt_doc_dt,
        "1_to_15_days_org_amt_doc_dt",
        "16_to_30_days_org_amt_doc_dt",
        "31_to_60_days_org_amt_doc_dt",
        "61_to_90_days_org_amt_doc_dt",
        "91_and_over_org_amt_doc_dt",
        sk_vendor_global,
        sk_doctype_global,
        status,
        source_type,
        exch_rate_today,
        sk_ap_global,
        date_trunc('week', current_date) as snapshot_week,
        date_part('week', current_date) as snapshot_week_number,
        current_timestamp()::timestamp_ltz as snapshot_datetime
    from {{ ref('fct__open_ap_transactions') }}
),

deduped as (
    select *
    from base_ap_data
    qualify row_number() over (
        partition by sk_ap_global
        order by snapshot_datetime desc
    ) = 1
)

select *
from deduped
where 
  dayofweek(current_date) = 5 --Friday
  and hour(current_timestamp()) >= 16 -- 4pm

{% if is_incremental() %}
    and not exists (
    select 1
    from {{ this }} t
    where t.sk_ap_global = deduped.sk_ap_global
        and t.snapshot_week = deduped.snapshot_week
    )

{% endif %}
