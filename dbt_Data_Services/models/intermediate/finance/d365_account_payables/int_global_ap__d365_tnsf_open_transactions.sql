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

vend_trans_open as (
    select *
    from {{ ref('stg_d365__vend_trans_open') }}
),

vend_trans as (
    select *
    from {{ ref('stg_d365__vend_trans') }}
),

open_payments as (
    select
        vend_open.*,
        vend_main.invoice,
        vend_main.transtype,
        vend_main.currencycode,
        vend_main.voucher,
        vend_main.paymtermid,
        vend_main.documentdate
    from vend_trans_open as vend_open
    left join vend_trans as vend_main
        on vend_open.refrecid = vend_main.recid
),

-- NEW: summarize invoice amounts for purchase amount calc
invoice_summary as (
    select
        inv.invoiceid,
        inv.documentdate,
        inv.currencycode,
        inv.ledgervoucher,
        sum(inv.salesbalance) as amt,
        round(sum(inv.sumtax), 3) as tax
    from {{ ref('stg_d365__vend_invoice_jour') }} as inv
    group by
        inv.invoiceid,
        inv.documentdate,
        inv.currencycode,
        inv.ledgervoucher
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
        open_paym.recid as transaction_id,
        comp_tnsf.fno_id as company_id,
        open_paym.accountnum as vendor_id,
        open_paym.transtype as document_type_id,
        open_paym.currencycode as currency_id,
        open_paym.voucher,
        '' as bach_number,
        open_paym.paymtermid,
        open_paym.createdby as userid,
        open_paym.invoice as document_number,
        cast(open_paym.documentdate as date) as document_date,
        cast(open_paym.transdate as date) as gl_posting_date,
        cast(open_paym.duedate as date) as due_date,
        '' as po_number,
        funl_curr.accountingcurrency as company_currency,

        open_paym.amountmst * (-1) as functional_document_amount,
        open_paym.reportingcurrencyamount * (-1) as functional_transaction_amount,
        open_paym.amountcur * (-1) as originating_document_amount,
        open_paym.amountcur * (-1) as originating_transaction_amount,

        {{ forex_convert('open_paym.currencycode', "'CAD'", 'originating_document_amount', 'rate_cad_doc.rate') }} as cad_amount,
        {{ forex_convert('open_paym.currencycode', "'USD'", 'originating_document_amount', 'rate_usd_doc.rate') }} as usd_amount,

        -- NEW: purchase amounts from invoice_summary (inv_sum)
        {{ forex_convert('inv_sum.currencycode', "'CAD'", 'inv_sum.amt', 'rate_cad_inv.rate') }} as cad_purchase_amount,
        {{ forex_convert('inv_sum.currencycode', "'USD'", 'inv_sum.amt', 'rate_usd_inv.rate') }} as usd_purchase_amount,

        {{ aging_buckets('open_paym.duedate', 'open_paym.documentdate', 'cad_amount') }},
        {{ aging_originating_buckets('open_paym.duedate', 'open_paym.documentdate', 'usd_amount') }},

        md5(concat(comp_tnsf.fno_id, trim(upper(open_paym.accountnum)), 'D365')) as sk_vendor_global,
        md5(concat(cast(open_paym.transtype as varchar), 'D365')) as sk_doctype_global,
        'OPEN' as status
    from open_payments as open_paym
    cross join company_tnsf as comp_tnsf
    cross join funlcurr as funl_curr

    -- rates for transaction amounts (by transdate + line currency)
    left join rate_cad as rate_cad_doc
        on cast(open_paym.transdate as date) = rate_cad_doc.fx_date
            and upper(trim(rate_cad_doc.from_ccy)) = upper(trim(open_paym.currencycode))
    left join rate_usd as rate_usd_doc
        on cast(open_paym.transdate as date) = rate_usd_doc.fx_date
            and upper(trim(rate_usd_doc.from_ccy)) = upper(trim(open_paym.currencycode))

    -- attach invoice summary for purchase amounts
    left join invoice_summary as inv_sum
        on open_paym.invoice = inv_sum.invoiceid
            and open_paym.voucher = inv_sum.ledgervoucher

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
