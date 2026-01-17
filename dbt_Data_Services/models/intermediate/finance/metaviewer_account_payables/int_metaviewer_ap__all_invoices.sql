-- ==========================================================
-- Model: int_metaviewer__ap_all_invoices
-- Owner of Data: Finance team
-- Version: 1.0
-- Purpose: Combines payables base (invoices/credits) with journal activities
--          into a unified table
-- PK for testing: SK_TRANSACTIONS_PK
-- ==========================================================

with company as (
    -- Company reference data (trimmed columns)
    select {{ trim_columns_int('stg_gp__company_name') }}
    from {{ ref('stg_gp__company_name') }}
),

-- funlcurr as (
--     -- Capture functional currency (ensuring a single consistent value)
--     select any_value(trim(funlcurr)) as funlcurr
--     from {{ ref('stg_gp_bhfc__mc40000') }}
-- ),

base as (
    -- Base invoices/credits from MetaViewer (header-level)
    select *
    from {{ ref('stg_metaviewer__payables_base') }}
    where cast(invoice_date as date) > '2023-12-31'
),

fxrates_cad as (
    -- Daily FX rates filtered to CAD
    select *
    from {{ ref('dim__daily_exchange_rates') }}
    where to_ccy = 'CAD'
    order by key_date desc
),

activities as (
    -- Journal activity history for invoices (row_number gives step order)
    select
        jid,
        docid,
        docstate,
        createdby,
        mimetype,
        datarev,
        activityid,
        userprofileid,
        duid,
        createdate,
        regexp_replace(usermessage, '<[^>]*>', '') as usermessage,
        row_number() over (partition by docid order by jid asc) as step_number
    from {{ ref('stg_metaviewer__journal') }}
    where createdate > '2023-12-31'
),

all_invoices as (
    -- enriched invoices: joins company + fx data
    select
        base.docid as transaction_id,
        company.interid as company_id,
        base.vendor as vendor_id,
        base.vendor_name,
        base.profile_id,
        base.approver_1,
        base.approver_2,
        base.approver_3,
        base.approver_4,
        base.approver_5,
        base.current_approver,
        base.transaction_description as description,
        base.payable_type,
        base.pre_approved,
        base.invoice_number as document_number,
        base.po_number,
        base.invoice_number,
        cast(base.invoice_date as date) as invoice_date,
        cast(base.due_date as date) as due_date,

        -- Standardize currency handling
        case
            when base.currency like '%Z-EURO%' then 'EUR'
            else coalesce(base.currency, 'CAD')
        end as transaction_currency,
        coalesce(fxrates_cad.rate, 1) as forex_rate,

        -- Monetary amounts (original + CAD converted)
        cast(base.invoice_amount as number(38)) as invoice_amount,
        {{ forex_convert('transaction_currency', "'CAD'", 'base.invoice_amount','FXRates_CAD.rate' ) }} as cad_amount,
        {{ forex_convert('transaction_currency', "'CAD'", 'base.misc_amount','FXRates_CAD.rate' ) }} as misc_cad_amt,
        {{ forex_convert('transaction_currency', "'CAD'", 'base.freight_amount','FXRates_CAD.rate' ) }} as freight_cad_amt,
        {{ forex_convert('transaction_currency', "'CAD'", 'base.tax_amount','FXRates_CAD.rate' ) }} as tax_cad_amt,

        -- activity placeholders for invoice-only records
        null as docstate,
        null as createdby,
        null as mimetype,
        null as datarev,
        null as activityid,
        null as usermessage,
        null as userprofileid,
        null as duid,
        cast(base.invoice_date as date) as createdate,

        -- default step_number
        0 as step_number,

        -- surrogate keys for company/vendor
        md5(concat(trim(upper(company.interid)), trim(upper(base.vendor)))) as sk_vendor_global,
        md5(trim(upper(company_id))) as sk_company_global
    from base
    left join company
        on trim(upper(base.company_id)) = trim(upper(company.cmpanyid))
    left join fxrates_cad
        on trim(fxrates_cad.from_ccy) = transaction_currency
            and cast(trim(base.invoice_date) as date) = cast(trim(fxrates_cad.key_date) as date)
),

invoice_activity as (
    -- journal activities joined with invoice headers
    select
        activities.docid as transaction_id,
        all_invoices.company_id,
        all_invoices.vendor_id,
        all_invoices.vendor_name,
        all_invoices.profile_id,
        all_invoices.approver_1,
        all_invoices.approver_2,
        all_invoices.approver_3,
        all_invoices.approver_4,
        all_invoices.approver_5,
        all_invoices.current_approver,
        all_invoices.description,
        all_invoices.payable_type,
        all_invoices.pre_approved,
        all_invoices.document_number,
        all_invoices.po_number,
        all_invoices.invoice_number,
        all_invoices.invoice_date,
        all_invoices.due_date,
        all_invoices.transaction_currency,
        all_invoices.forex_rate,

        -- override amounts (activity rows don’t carry invoice totals)
        cast(0 as number(38)) as invoice_amount,
        cast(0 as number(38)) as cad_amount,
        cast(0 as number(38)) as misc_cad_amt,
        cast(0 as number(38)) as freight_cad_amt,
        cast(0 as number(38)) as tax_cad_amt,

        -- activity-specific fields
        activities.docstate,
        activities.createdby,
        activities.mimetype,
        activities.datarev,
        activities.activityid,
        activities.usermessage,
        activities.userprofileid,
        activities.duid,
        activities.createdate,
        activities.step_number,

        -- surrogate keys for company/vendor
        all_invoices.sk_vendor_global,
        all_invoices.sk_company_global
    from activities
    left join all_invoices
        on activities.docid = all_invoices.transaction_id
),

combined as (
    -- final unified grouping: invoices step_number + activities
    select
        combined_inner.*,
        lag(combined_inner.activityid) over (
            partition by combined_inner.transaction_id order by combined_inner.createdate
        ) as prev_activityid,
        lag(combined_inner.createdate) over (
            partition by combined_inner.transaction_id order by combined_inner.createdate
        ) as prev_time,
        min(combined_inner.createdate) over (
            partition by combined_inner.transaction_id
        ) as min_activity_time,
        max(combined_inner.createdate) over (
            partition by combined_inner.transaction_id
        ) as max_activity_time,

        row_number() over (
            partition by combined_inner.transaction_id
            order by combined_inner.createdate desc
        ) as step_identifier,

        -- surrogate transaction key = transaction_id + step_number
        md5(
            concat(
                trim(upper(cast(combined_inner.transaction_id as string))),
                trim(upper(cast(coalesce(combined_inner.step_number, 0) as string)))
            )
        ) as sk_transaction_pk
    from (
        select * from invoice_activity
        union all
        select * from all_invoices
    ) as combined_inner
),

final as (
    select
        *,
        datediff(day, prev_time, createdate) as days_since_prev,
        datediff(day, min_activity_time, max_activity_time) as workflow_time,
        case
            when step_identifier = 1
                then 1
            else 0
        end as flag_last_step,

        sum(
            case
                when activityid = 1003
                    or (activityid = 3 and prev_activityid = 3)
                    then 1
                else 0
            end
        ) over (
            partition by transaction_id order by createdate
        ) as approval_stage,

        max(
            case
                when activityid = 1002 then 1
                else 0
            end
        ) over (
            partition by transaction_id
        ) as flag_activity_1002
    from combined
)

select * from final
