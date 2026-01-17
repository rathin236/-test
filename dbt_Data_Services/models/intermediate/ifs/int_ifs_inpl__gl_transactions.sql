with gen_led_voucher_row_tab as (
    select * from {{ ref('stg_ifs__gen_led_voucher_row_tab') }}
),

codestring_comb_tab as (
    select * from {{ ref('stg_ifs__codestring_comb_tab') }}
),

accounting_code_part_value_tab as (
    select * from {{ ref('stg_ifs__accounting_code_part_value_tab') }}
),

purchase_order_tab as (
    select * from {{ ref('stg_ifs__purchase_order_tab') }}
),

supplier_info_tab as (
    select * from {{ ref('stg_ifs__supplier_info_tab') }}
),

invoice_tab as (
    select * from {{ ref('stg_ifs__invoice_tab') }}
),

inpl_gl_transactions as (
    select

        gvr.company,
        '' as transactionstatus,
        gvr.voucher_date as transactiondate,
        gvr.year_period_key as period,
        gvr.voucher_no as journalentrynumber,
        cct.account as naturalnumber,
        cct.code_b as costcenternumber,
        cct.code_c as locationnumber,
        cct.code_h as projectnumber,
        nnd.description as naturalnumberdescription,
        ccd.description as costcenterdescription,
        lnd.description as locationdescription,
        pnd.description as projectdescription,
        gvr.currency_credit_amount as currencycreditamount,
        gvr.currency_debet_amount as currencydebitamount,
        gvr.debet_amount as debitamount,
        gvr.credit_amount as creditamount,
        gvr.text as description,
        poh.order_date as documentdate,
        cct.code_i as currency,
        gvr.currency_rate as exchangerate,
        cct.code_e as productnumber,
        dnd.description as productdescription,
        sit.name as vendorname,
        gvr.quantity,
        coalesce(cast(ivt.identity as string), poh.vendor_no) as vendorid,
        coalesce(cast(ivt.invoice_id as string), poh.order_no) as documentnumber,
        concat(
            trim(coalesce(cct.account, '')),
            '-',
            trim(coalesce(cct.code_b, '0000')),
            '-',
            trim(coalesce(cct.code_c, '0000'))
        ) as accountnumber,
        coalesce(gvr.currency_debet_amount, 0) - coalesce(gvr.currency_credit_amount, 0) as currencyamount,
        coalesce(gvr.debet_amount, 0) - coalesce(gvr.credit_amount, 0) as amount

    from gen_led_voucher_row_tab as gvr

    left join codestring_comb_tab as cct
        on gvr.posting_combination_id = cct.posting_combination_id

    left join accounting_code_part_value_tab as acv
        on gvr.company = acv.company
            and acv.code_part = 'A'
            and cct.account = acv.code_part_value

    left join accounting_code_part_value_tab as nnd
        on gvr.company = nnd.company
            and nnd.code_part = 'A'
            and cct.account = nnd.code_part_value

    left join accounting_code_part_value_tab as ccd
        on gvr.company = ccd.company
            and ccd.code_part = 'B'
            and cct.code_b = ccd.code_part_value

    left join accounting_code_part_value_tab as lnd
        on gvr.company = lnd.company
            and lnd.code_part = 'C'
            and cct.code_c = lnd.code_part_value

    left join accounting_code_part_value_tab as pnd
        on gvr.company = pnd.company
            and pnd.code_part = 'H'
            and cct.code_h = pnd.code_part_value

    left join accounting_code_part_value_tab as dnd
        on gvr.company = dnd.company
            and dnd.code_part = 'E'
            and cct.code_e = dnd.code_part_value

    left join purchase_order_tab as poh
        on gvr.reference_number = poh.order_no

    left join invoice_tab as ivt
        on gvr.company = ivt.company
            and gvr.voucher_no = ivt.voucher_no_ref
            and gvr.voucher_date = ivt.voucher_date_ref
            and gvr.reference_serie = ivt.series_id

    left join supplier_info_tab as sit
        on coalesce(ivt.identity, poh.vendor_no) = sit.supplier_id

    where
        gvr.company = 'INPL'
        --and gvr.accounting_year in ('2020', '2021', '2022', '2023')
        and gvr.accounting_year >= '2020'
)

select * from inpl_gl_transactions
