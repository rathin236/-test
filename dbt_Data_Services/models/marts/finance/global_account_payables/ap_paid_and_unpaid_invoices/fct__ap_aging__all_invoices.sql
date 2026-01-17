with paid_invoices as (
    select
        company_id,
        vendor_id,
        document_type_id,
        po_number,
        company_currency,
        voucher,
        status,
        document_number,
        document_date,
        gl_posting_date,
        due_date,
        currency_id,
        functional_document_amount,
        originating_document_amount,
        cad_amount,
        usd_amount,
        cad_purchase_amount,
        usd_purchase_amount,
        originating_transaction_amount,
        functional_transaction_amount,
        sk_vendor_global,
        sk_doctype_global,
        source_type,
        days_to_pay,
        po_type,
        days_to_overdue,
        sk_ap_global
    from {{ ref('fct__ap_aging__paid_invoices') }}
),

payment_status as (
    select
        *,
        case
            when days_to_overdue < 0 and days_to_overdue > -31 then 'OVERDUE 1 to 30'
            when days_to_overdue < -30 and days_to_overdue > -61 then 'OVERDUE 31 to 60'
            when days_to_overdue < -60 and days_to_overdue > -91 then 'OVERDUE 31 to 60'
            when days_to_overdue < -90 then 'OVERDUE 90+'

            when days_to_overdue >= 0 and days_to_pay > -1 and days_to_pay < 31 then 'PAID - 1 to 30'
            when days_to_overdue >= 0 and days_to_pay > 30 and days_to_pay < 61 then 'PAID - 31 to 60'
            when days_to_overdue >= 0 and days_to_pay > 60 then 'PAID - 60+'

            when days_to_pay < 0 and days_to_overdue > -1 and days_to_overdue < 31 then 'PAID - 1 to 30'
            when days_to_pay < 0 and days_to_overdue > 30 and days_to_overdue < 61 then 'PAID - 31 to 60'
            when days_to_pay < 0 and days_to_overdue > 60 then 'PAID - 60+'

            else 'NA'
        end as payment_status,

        case
            when days_to_overdue < 0 and days_to_overdue > -31 then 'OVERDUE 1 to 30'
            when days_to_overdue < -30 and days_to_overdue > -61 then 'OVERDUE 31 to 60'
            when days_to_overdue < -60 and days_to_overdue > -91 then 'OVERDUE 31 to 60'
            when days_to_overdue < -90 and days_to_overdue >= -181 then 'OVERDUE 91 to 180'
            when days_to_overdue < -181 then 'OVERDUE 181+'

            when days_to_overdue >= 0 and days_to_pay > -1 and days_to_pay < 31 then 'PAID - 1 to 30'
            when days_to_overdue >= 0 and days_to_pay > 30 and days_to_pay < 61 then 'PAID - 31 to 60'
            when days_to_overdue >= 0 and days_to_pay > 60 then 'PAID - 60+'

            when days_to_overdue >= 0 and days_to_pay > -1 and days_to_pay < 31 then 'PAID - 1 to 30'
            when days_to_overdue >= 0 and days_to_pay > 30 and days_to_pay < 61 then 'PAID - 31 to 60'
            when days_to_overdue >= 0 and days_to_pay > 60 then 'PAID - 60+'

            when days_to_pay < 0 and days_to_overdue > -1 and days_to_overdue < 31 then 'PAID - 1 to 30'
            when days_to_pay < 0 and days_to_overdue > 30 and days_to_overdue < 61 then 'PAID - 31 to 60'
            when days_to_pay < 0 and days_to_overdue > 60 then 'PAID - 60+'

            else 'NA'
        end as payment_status_treasury
    from paid_invoices
),

unpaid_invoices as (
    select
        *,
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
        end as payment_status,

        case
            when days_to_overdue < 0 and days_to_overdue >= -30 then 'OVERDUE 1 to 30'
            when days_to_overdue <= -30 and days_to_overdue >= -60 then 'OVERDUE 31 to 60'
            when days_to_overdue <= -60 and days_to_overdue >= -90 then 'OVERDUE 61 to 90'
            when days_to_overdue <= -91 and days_to_overdue >= -181 then 'OVERDUE 91 to 180'
            when days_to_overdue <= -181 then 'OVERDUE 181+'

            when days_to_overdue = 0 then 'DUE TODAY'
            when days_to_overdue > 0 and days_to_overdue < 31 then 'DUE 1 to 30'
            when days_to_overdue > 30 and days_to_overdue < 61 then 'DUE 31 to 60'
            when days_to_overdue > 60 and days_to_overdue < 91 then 'DUE 61 to 90'
            when days_to_overdue > 90 and days_to_overdue < 181 then 'DUE 91 to 180'
            when days_to_overdue >= 181 then 'DUE 181+'

            else 'NA'
        end as payment_status_treasury
    from {{ ref('fct__ap_aging__unpaid_invoices') }}
),

all_aging as (
    select * from payment_status
    union distinct
    select * from unpaid_invoices
)

select * from all_aging
