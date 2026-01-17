{{
  config(
    materialized = 'incremental',
    unique_key = 'sk_ap_global || snapshot_week',
    incremental_strategy = 'insert_overwrite',
    partition_by = {"field": "snapshot_week", "data_type": "date"}
  )
}}

with live_data as (
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

snapshot as (
    select * from {{ ref('fct__open_ap_transactions_weekly_snapshot') }}
),

final as (
    select * from live_data

    union all

    select * from snapshot
)

select * from final