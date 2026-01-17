with gl_accounts as (
    select * from {{ ref('stg_concur__gp_account_codes') }}
),

distributions as (
    select
        jel.debit_or_credit as debitorcredit,
        gpc.clearing_account,
        ere.payment_type_code,
        erh.report_id,
        ere.payment_type_name,
        erh.user_last_name,
        erh.user_first_name,
        jel.account_code,
        itl.cost_centre_code as costcentrecode,
        itl.department_code,
        erh.paid_date as paiddate,
        gl_accts.natural_acct_code,
        case
            when cpt.gp_vendor_id = 'ERH.VendorID' then erh.vendor_id
            when cpt.gp_vendor_id is null then 'UNDEFINED in XREF'
            else cpt.gp_vendor_id
        end as vendor_id,
        trim(gl_accts.account_number) as account_number,
        case
            when
                ere.payment_type_code = 'CASH'
                then to_varchar(max(ere.transaction_date), 'MM/yy')
            else to_varchar(max(ere.posted_date), 'MM/yy')
        end as posted_date,
        coalesce(gpc.gp_database, old.gp_database) as gp_database,
        case
            when cpt.bill_to_currency = 'TRANS'
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

            when cpt.bill_to_currency = 'HOME'
                then
                    sum(case
                        when erh.currency_code != ere.billing_currency
                            then
                                coalesce(
                                    itl.transaction_amount, ere.billing_amount
                                )
                        else jel.amount
                    end)
            else 0
        end as transactionamount,
        case
            when cpt.bill_to_currency = 'TRANS'
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

            when cpt.bill_to_currency = 'HOME'
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
        end as billingamount,
        sum(jel.amount) as approvedamount,
        case
            when jel.debit_or_credit = 'DR'
                then
                    {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}
            when jel.debit_or_credit = 'CR'
                then
                    'C' || {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}
            else 'UNDEFINED'
        end as r_idmonthyear,
        case
            when cpt.bill_to_currency = 'TRANS'
                then
                    case
                        when
                            coalesce(
                                ere.billing_currency,
                                ere.transaction_currency_code
                            )
                            != erh.currency_code
                            then
                                coalesce(
                                    ere.billing_currency,
                                    ere.transaction_currency_code
                                )
                        else erh.currency_code
                    end
            else erh.currency_code
        end as billingcurrency,
        coalesce(gpc.ledger_name, old.ledger_name) as ledger_name,
        coalesce(gpc.doctype_debit, old.doctype_debit) as doctype_debit,
        coalesce(gpc.doctype_credit, old.doctype_credit) as doctype_credit
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

    left join {{ ref('stg_gp__company') }} as old
        on
            old.company_code = erh.source_company
            and old.financial_system = 'GP'
            and old.gp_to_concur = 0

    left join {{ ref('stg_concur__payment_type') }} as cpt
        on
            erh.ledger_name = cpt.ledger_name
            and ere.payment_type_code = cpt.payment_type_code
            and ere.payment_type_name = cpt.payment_type_name
            and erh.currency_code = cpt.preferred_currency

    left join
        {{ ref('stg_gp_cpqln__pm00200') }} as pm200
        on trim(pm200.vendor_id) = coalesce(erh.vendor_id, cpt.gp_vendor_id)

    left join gl_accounts as gl_accts
        on
            gpc.gp_database = trim(gl_accts.company)
            and trim(gl_accts.account_index) = trim(pm200.pmapindx)

    /* for testing */
    -- where erh.report_id = '96DABFCC9A39445DB53A'

    group by
        jel.debit_or_credit,
        cpt.gp_vendor_id,
        erh.vendor_id,
        gl_accts.account_number,
        ere.payment_type_code,
        erh.report_id,
        ere.payment_type_name,
        erh.user_last_name,
        erh.user_first_name,
        gpc.gp_database,
        jel.account_code,
        itl.cost_centre_code,
        itl.department_code,
        erh.paid_date,
        erh.currency_code,
        ere.billing_currency,
        itl.transaction_amount,
        ere.billing_amount,
        ere.transaction_amount,
        jel.amount,
        erh.ledger_name,
        gpc.ledger_name,
        gpc.doctype_debit,
        gpc.doctype_credit,
        old.ledger_name,
        old.doctype_debit,
        old.doctype_credit,
        old.gp_database,
        gpc.clearing_account,
        ere.transaction_currency_code,
        cpt.bill_to_currency,
        gl_accts.company,
        gl_accts.account_index,
        pm200.pmapindx,
        pm200.vendor_id,
        gl_accts.natural_acct_code
),

-- select * from distributions;

distributions_lineitems as (
    select
        report_id,
        gp_database,
        payment_type_name,
        payment_type_code,
        debitorcredit,
        vendor_id as vendorid,
        6 as dist_type,
        billingcurrency,
        paiddate,
        r_idmonthyear,
        case
            when debitorcredit = 'DR' then doctype_debit
            else doctype_credit
        end as doctype,
        case
            when debitorcredit = 'DR'
                then
                    posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
            when debitorcredit = 'CR'
                then
                    'C'
                    || posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
            else 'UNDEFINED'
        end as docnumbr,
        case
            when len(account_code) > len(max(natural_acct_code))
                then account_code
            when
                exists (
                    select trim(account_number) from gl_accounts
                    where
                        trim(status) = 'ACTIVE'
                        and trim(company) = gp_database
                        and trim(account_number)
                        = account_code
                        || '-'
                        || costcentrecode
                        || '-'
                        || department_code
                )
                then
                    account_code
                    || '-'
                    || costcentrecode
                    || '-'
                    || department_code
            else clearing_account
        end as account_number,
        sum(case
            when debitorcredit = 'DR' then round(billingamount, 2)
            else 0
        end) as debitamt,
        sum(case
            when debitorcredit = 'CR' then abs(round(billingamount, 2))
            else 0
        end) as crdtamnt

    from distributions

    group by
        debitorcredit,
        gp_database,
        payment_type_name,
        vendorid,
        payment_type_code,
        posted_date,
        report_id,
        user_last_name,
        user_first_name,
        account_code,
        costcentrecode,
        department_code,
        paiddate,
        r_idmonthyear,
        billingcurrency,
        doctype_debit,
        doctype_credit,
        account_number,
        clearing_account
),

distribution_report_total as (
    select
        report_id,
        gp_database,
        payment_type_name,
        payment_type_code,
        debitorcredit,
        vendor_id as vendorid,
        2 as dist_type,
        account_number,
        billingcurrency,
        paiddate,
        r_idmonthyear,
        case
            when debitorcredit = 'DR' then doctype_debit
            else doctype_credit
        end as doctype,
        case
            when debitorcredit = 'DR'
                then
                    posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
            when debitorcredit = 'CR'
                then
                    'C'
                    || posted_date
                    || ' '
                    || right(report_id, 4)
                    || ' '
                    || concat(user_last_name, ', ', left(user_first_name, 1))
            else 'UNDEFINED'
        end as docnumbr,
        sum(case
            when debitorcredit = 'CR' then round(billingamount, 2)
            else 0
        end) as debitamt,
        sum(case
            when debitorcredit = 'DR' then abs(round(billingamount, 2))
            else 0
        end) as crdtamnt

    from distributions

    group by
        report_id,
        gp_database,
        payment_type_name,
        payment_type_code,
        debitorcredit,
        doctype,
        vendor_id,
        user_last_name,
        user_first_name,
        account_number,
        billingcurrency,
        posted_date,
        paiddate,
        r_idmonthyear,
        doctype_debit,
        doctype_credit
)

select
    report_id,
    gp_database,
    payment_type_name,
    payment_type_code,
    debitorcredit,
    doctype,
    vendorid,
    dist_type,
    docnumbr as distref,
    account_number,
    debitamt,
    crdtamnt,
    paiddate,
    r_idmonthyear,
    billingcurrency

from distribution_report_total

union all

select
    report_id,
    gp_database,
    payment_type_name,
    payment_type_code,
    debitorcredit,
    doctype,
    vendorid,
    dist_type,
    docnumbr as distref,
    account_number,
    debitamt,
    crdtamnt,
    paiddate,
    r_idmonthyear,
    billingcurrency

from distributions_lineitems
