with transactions as (
    select
        jel.account_code,
        jel.debit_or_credit,
        erh.report_id,
        erh.user_last_name,
        erh.user_first_name,
        gppm.tax_schedule_id,
        erh.paid_date,
        gpc.gp_database,
        ere.payment_type_name,
        case
            when cpt.gp_vendor_id = 'ERH.VendorID' then erh.vendor_id
            when cpt.gp_vendor_id is null then 'UNDEFINED in XREF'
            else cpt.gp_vendor_id
        end as vendor_id,
        case
            when
                ere.payment_type_code = 'CASH'
                then to_varchar(ere.transaction_date, 'MM/yy')
            else to_varchar(ere.posted_date, 'MM/yy')
        end as posted_date,
        coalesce(to_date(ere.posted_date), to_date(ere.transaction_date))
            as document_date,
        case
            when jel.debit_or_credit = 'DR' then gpc.doctype_debit
            else gpc.doctype_credit
        end as document_type,
        ere.transaction_amount / nullifzero(ere.billing_amount) as fx_rate,
        case
            when
                cpt.bill_to_currency = 'TRANS'
                then
                    sum(case
                        when
                            erh.currency_code
                            != coalesce(
                                ere.billing_currency,
                                ere.transaction_currency_code
                            )
                            then
                                coalesce(
                                    itl.transaction_amount, ere.billing_amount
                                )
                        else jel.amount
                    end)

            when
                cpt.bill_to_currency = 'HOME'
                then
                    sum(case
                        when erh.currency_code != ere.billing_currency
                            then
                                coalesce(
                                    itl.transaction_amount, ere.billing_amount
                                )
                                / (
                                    ere.transaction_amount
                                    / nullifzero(ere.billing_amount)
                                )
                        else jel.amount
                    end)
            else 0
        end as total_purchase,
        case
            when ere.payment_type_code = 'CASH' then erh.currency_code
            else ere.billing_currency
        end as currency_id,
        case
            when jel.debit_or_credit = 'DR'
                then
                    {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}
            when jel.debit_or_credit = 'CR'
                then
                    'C' || {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}
            else 'UNDEFINED'
        end as r_idmonthyear

    from {{ ref('stg_concur__expense_report_header' ) }} as erh

    left join
        {{ ref('stg_concur__expense_report_entries') }} as ere
        on erh.report_id = ere.report_id

    left join
        {{ ref('stg_concur__itemization_list') }} as itl
        on ere.report_entry_id = itl.report_entry_id

    left join
        {{ ref('stg_concur__allocations_list') }} as als
        on itl.itemization_id = als.itemization_id

    left join
        {{ ref('stg_concur__journal_entries_list') }} as jel
        on als.allocation_id = jel.allocation_id

    left join {{ ref('stg_gp__company') }} as gpc
        on
            gpc.company_code = erh.source_company
            and gpc.financial_system = 'GP'
            and gpc.gp_to_concur = 1

    left join
        {{ ref('stg_gp_cpqln__pm00200') }} as gppm
        on trim(gppm.vendor_id) = erh.vendor_id

    left join {{ ref('stg_concur__payment_type') }} as cpt
        on
            erh.ledger_name = cpt.ledger_name
            and ere.payment_type_code = cpt.payment_type_code
            and ere.payment_type_name = cpt.payment_type_name
            and erh.currency_code = cpt.preferred_currency

    /* for testing */
    -- where erh.report_id = '96DABFCC9A39445DB53A'

    group by
        jel.account_code,
        jel.debit_or_credit,
        erh.report_id,
        erh.vendor_id,
        ere.payment_type_name,
        ere.payment_type_code,
        ere.transaction_date,
        ere.posted_date,
        erh.user_last_name,
        erh.user_first_name,
        jel.amount,
        gppm.tax_schedule_id,
        erh.paid_date,
        cpt.gp_vendor_id,
        erh.ledger_name,
        gpc.gp_database,
        erh.source_company,
        ere.billing_currency,
        ere.billing_amount,
        ere.transaction_amount,
        itl.transaction_amount,
        erh.currency_code,
        ere.transaction_currency_code,
        ere.payment_type_name,
        gpc.doctype_debit,
        gpc.doctype_credit,
        cpt.bill_to_currency
),

/* CTE transaction_insert compiles all fields needed
for taPMTransactionInsert XML block to send to GP */
transaction_insert as (
    select
        report_id,
        debit_or_credit,
        vendor_id as vendorid,
        document_type as doctype,
        tax_schedule_id as taxschid,
        0 as taxamnt,
        0 as createdist,
        paid_date as paiddate,
        r_idmonthyear,
        gp_database as gpdatabase,
        currency_id as curncyid,
        'Con-'
        || to_char(current_date(), 'yymmdd')
        || '-'
        || right(report_id, 4) as bachnumb,
        case
            when debit_or_credit = 'DR'
                then
                    posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
                    || ' '
                    || currency_id
                    || ' '
                    || substr(upper(payment_type_name), 1, 3)
            when debit_or_credit = 'CR'
                then
                    'C'
                    || posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
                    || ' '
                    || currency_id
                    || ' '
                    || substr(upper(payment_type_name), 1, 3)
            else 'UNDEFINED'
        end as docnumbr,
        sum(abs(total_purchase)) as docamnt,
        last_day(document_date) as docdate,
        date_trunc(month, paid_date) as posted_date,
        sum(abs(coalesce(total_purchase, 0))) as prchamnt,
        sum(abs(coalesce(total_purchase, 0))) as chrgamnt,
        left(user_last_name || ', ' || user_first_name, 30) as trxdscrn

    from transactions

    group by
        report_id,
        debit_or_credit,
        user_last_name,
        user_first_name,
        document_type,
        last_day(document_date),
        posted_date,
        vendor_id,
        trxdscrn,
        tax_schedule_id,
        taxschid,
        paid_date,
        r_idmonthyear,
        gp_database,
        currency_id,
        payment_type_name
)

/* This is the final query that produces the resultset */
select * from transaction_insert
