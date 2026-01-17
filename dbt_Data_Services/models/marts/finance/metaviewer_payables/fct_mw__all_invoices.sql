-- ==========================================================
-- Model: fct_metaviewer__ap_invoice_status_snapshot
-- Owner of Data: Finance team
-- Version: 1.0
-- Purpose: Creates a time snapshot of invoices/activities
--          from MetaViewer, including due date calculations, flags,
--          and payment status.
-- PK for testing: SK_TRANSACTION_PK + SNAPSHOT_DATETIME
-- ==========================================================
with base as (
    select *
    from {{ ref('int_metaviewer_ap__all_invoices') }}
),

-- find first payment date per transaction
payments as (
    select
        transaction_id,
        min(createdate) as payment_date
    from {{ ref('int_metaviewer_ap__all_invoices') }}
    where activityid = 1008
    group by transaction_id
),

status as (
    select
        base.*,
        pay.payment_date,

        -- days calc
        datediff('day', base.due_date, current_date) as days_to_overdue,
        datediff('day', base.due_date, pay.payment_date) as days_to_pay,

        (coalesce(base.due_date, current_date) - current_date) as due_in_days,

        -- existing statuses
        case
            when base.due_date is null then null
            when base.due_date < current_date then 'Overdue'
            when base.due_date = current_date then 'Due TODAY'
            else 'Due in ' || to_varchar(datediff('day', current_date, base.due_date)) || ' Day(s)'
        end as due_date_status,

        case
            when base.due_date is null then null
            when (base.due_date - current_date) < 0 then 'Overdue'
            when (base.due_date - current_date) <= 7 then 'At Risk'
            else 'OK'
        end as remaining_days_status,

        max(case when base.activityid = 1010 then 1 else 0 end)
            over (partition by base.transaction_id) as flag_approved,

        case
            when base.usermessage ilike '%Bypassing export%' then 1
            else 0
        end as flag_bypassed,

        case
            when base.usermessage ilike '%Voided%'
                or base.usermessage ilike '%deletion%' then 1
            else 0
        end as flag_cancelled,

        case
            when exists (
                    select 1
                    from {{ ref('int_metaviewer_ap__all_invoices') }} as paid
                    where paid.transaction_id = base.transaction_id
                        and paid.activityid = 1008
                ) then 1
            else 0
        end as flag_paid,

        case
            when max(case when base.activityid = 1008 then 1 else 0 end)
                    over (partition by base.transaction_id)
                > 0
                then 'Paid'
            else 'Not Paid'
        end as flag_payment,

        case
            when max(case when base.activityid = 1008 then 1 else 0 end)
                    over (partition by base.transaction_id)
                = 0
                and base.due_date is not null
                and current_date > base.due_date
                then 1
            else 0
        end as flag_overdue,

        case
            when (base.due_date - current_date) < 0
                and max(case when base.activityid = 1008 then 1 else 0 end)
                    over (partition by base.transaction_id)
                = 0
                then 1
            else 0
        end as flag_overdue_2,

        case
            -- unpaid invoices
            when flag_payment = 'Not Paid'
                then
                    case
                        when days_to_overdue < 0 and days_to_overdue >= -30 then 'OVERDUE 1 to 30'
                        when days_to_overdue <= -30 and days_to_overdue >= -60 then 'OVERDUE 31 to 60'
                        when days_to_overdue <= -60 and days_to_overdue >= -90 then 'OVERDUE 61 to 90'
                        when days_to_overdue <= -90 then 'OVERDUE 90+'
                        when days_to_overdue = 0 then 'DUE TODAY'
                        when days_to_overdue > 0 and days_to_overdue < 31 then 'DUE 1 to 30'
                        when days_to_overdue > 30 and days_to_overdue < 61 then 'DUE 31 to 60'
                        when days_to_overdue > 60 and days_to_overdue < 91 then 'DUE 61 to 90'
                        when days_to_overdue > 90 then 'DUE 90+'
                        else 'NA'
                    end

                    -- paid invoices
            when flag_payment = 'Paid' and pay.payment_date is not null
                then
                    case
                        -- paid late
                        when pay.payment_date > base.due_date
                            then
                                case
                                    when days_to_pay between 1 and 30 then 'OVERDUE 1 to 30'
                                    when days_to_pay between 31 and 60 then 'OVERDUE 31 to 60'
                                    when days_to_pay between 61 and 90 then 'OVERDUE 61 to 90'
                                    when days_to_pay > 90 then 'OVERDUE 90+'
                                end

                        -- paid on-time or early
                        when pay.payment_date <= base.due_date then
                            case
                                when days_to_pay between 0 and 30 then 'PAID - 1 to 30'
                                when days_to_pay between 31 and 60 then 'PAID - 31 to 60'
                                when days_to_pay > 60 then 'PAID - 60+'
                            end
                    end
            else 'NA'
        end as payment_status
    from base
    left join payments as pay
        on base.transaction_id = pay.transaction_id
)

select *
from status
