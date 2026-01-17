with company as (
    select
        {{ trim_columns_int('stg_d365__data_area') }}
    from {{ ref('stg_d365__data_area') }}
),

company_tnsf as (
    select comp_all.fno_id
    from company as comp_all
    where upper(trim(comp_all.fno_id)) = 'TNSF'
    qualify row_number() over (order by comp_all.fno_id) = 1
),

ledger as (
    select *
    from {{ ref('stg_d365__ledger') }}
),

funlcurr as (
    select ledger_tbl.accountingcurrency
    from ledger as ledger_tbl
    inner join company_tnsf as comp_tnsf
        on ledger_tbl.name = comp_tnsf.fno_id
    qualify row_number() over (order by ledger_tbl.accountingcurrency) = 1
),

paid_invoices as (
    select {{ trim_columns_int('stg_d365__vend_trans') }} from {{ ref('stg_d365__vend_trans') }}
    where cast(closed as date) > '2000-01-01'
),

-- NEW: summarize invoice amounts for purchase amount calc
invoice_summary as (
    select
        inv.invoiceid,
        inv.purchid,
        inv.documentdate,
        inv.duedate,
        inv.currencycode,
        inv.ledgervoucher,
        sum(inv.salesbalance) as amt,
        round(sum(inv.sumtax), 3) as tax
    from {{ ref('stg_d365__vend_invoice_jour') }} as inv
    group by
        inv.invoiceid,
        inv.purchid,
        inv.documentdate,
        inv.currencycode,
        inv.ledgervoucher,
        inv.duedate
),

dim_exchange_rates as (
    select *
    from {{ ref('dim_exchange_rates') }}
),

rate_cad as (
    select dx_rates.*
    from dim_exchange_rates as dx_rates
    where upper(trim(dx_rates.to_ccy)) = 'CAD'
),

rate_usd as (
    select dx_rates.*
    from dim_exchange_rates as dx_rates
    where upper(trim(dx_rates.to_ccy)) = 'USD'
),

fact_tnsf_ap as (
    select
        paid_invoices.recid as transaction_id,
        comp_tnsf.fno_id as company_id,
        paid_invoices.accountnum as vendor_id,
        paid_invoices.transtype as document_type_id,
        paid_invoices.currencycode as currency_id,
        paid_invoices.voucher,
        '' as bach_number,
        paid_invoices.paymtermid,
        paid_invoices.createdby as userid,
        paid_invoices.invoice as document_number,
        cast(inv_sum.documentdate as date) as document_date,
        cast(paid_invoices.transdate as date) as gl_posting_date,
        cast(inv_sum.duedate as date) as due_date,
        inv_sum.purchid as po_number,
        funl_curr.accountingcurrency as company_currency,

        paid_invoices.amountmst * (-1) as functional_document_amount,
        paid_invoices.reportingcurrencyamount * (-1) as functional_transaction_amount,
        paid_invoices.amountcur * (-1) as originating_document_amount,
        paid_invoices.amountcur * (-1) as originating_transaction_amount,

        {{ forex_convert('paid_invoices.currencycode', "'CAD'", 'originating_document_amount', 'rate_cad_doc.rate') }} as cad_amount,
        {{ forex_convert('paid_invoices.currencycode', "'USD'", 'originating_document_amount', 'rate_usd_doc.rate') }} as usd_amount,

        -- NEW: purchase amounts from invoice_summary (inv_sum)
        {{ forex_convert('inv_sum.currencycode', "'CAD'", 'inv_sum.amt', 'rate_cad_inv.rate') }} as cad_purchase_amount,
        {{ forex_convert('inv_sum.currencycode', "'USD'", 'inv_sum.amt', 'rate_usd_inv.rate') }} as usd_purchase_amount,

        -(document_date - gl_posting_date) as days_to_pay,
        (due_date - gl_posting_date) as days_to_overdue,

        md5(concat(comp_tnsf.fno_id, trim(upper(paid_invoices.accountnum)), 'D365')) as sk_vendor_global,
        md5(concat(cast(paid_invoices.transtype as varchar), 'D365')) as sk_doctype_global,
        'PAID' as status
    from paid_invoices
    cross join company_tnsf as comp_tnsf
    cross join funlcurr as funl_curr

    -- rates for transaction amounts (by transdate + line currency)
    left join rate_cad as rate_cad_doc
        on cast(paid_invoices.transdate as date) = rate_cad_doc.fx_date
            and upper(trim(rate_cad_doc.from_ccy)) = upper(trim(paid_invoices.currencycode))
    left join rate_usd as rate_usd_doc
        on cast(paid_invoices.transdate as date) = rate_usd_doc.fx_date
            and upper(trim(rate_usd_doc.from_ccy)) = upper(trim(paid_invoices.currencycode))

    -- attach invoice summary for purchase amounts
    left join invoice_summary as inv_sum
        on paid_invoices.invoice = inv_sum.invoiceid
            and paid_invoices.voucher = inv_sum.ledgervoucher
            and paid_invoices.currencycode = inv_sum.currencycode

    -- rates for purchase amounts (by invoice document date + invoice currency)
    left join rate_cad as rate_cad_inv
        on cast(inv_sum.documentdate as date) = rate_cad_inv.fx_date
            and upper(trim(rate_cad_inv.from_ccy)) = upper(trim(inv_sum.currencycode))
    left join rate_usd as rate_usd_inv
        on cast(inv_sum.documentdate as date) = rate_usd_inv.fx_date
            and upper(trim(rate_usd_inv.from_ccy)) = upper(trim(inv_sum.currencycode))
)

select *
from fact_tnsf_ap
