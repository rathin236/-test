with expense as (
    select
        erh.report_id,
        erh.paid_date,
        ere.payment_type_code,
        '2' as dist_type,
        '' as taxaccount,
        erh.user_first_name,
        erh.user_last_name,
        '' as costcentrecode,
        '' as departmentcode,
        ccd.gp_database as source_companycode,
        '' as destcompanycode,
        '' as accountcode,
        jel.debit_or_credit as drorcr,
        concat((case when jel.debit_or_credit = 'CR' then 'C' else '' end), left((case when jel.debit_or_credit = 'DR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else (case when jel.debit_or_credit = 'CR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else 'ERROR' end) end), 2), '/', right((case when jel.debit_or_credit = 'DR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else (case when jel.debit_or_credit = 'CR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else 'ERROR' end) end), 2), right(erh.report_id, 4), sum(abs(case
            when gtd.tax_detail_id like '%PST%' or gtd.tax_detail_id like '%QST%' then cast(coalesce(itl.qst_value, 0) as number(20, 2))
            when gtd.tax_detail_id like '%HST%' or gtd.tax_detail_id like '%GST%' then cast(coalesce(itl.hst_value, 0) as number(20, 2))
            else cast('0' as number(20, 2))
        end))
        +
        sum(case
            when gtd.tax_detail_id like '%PST%' or gtd.tax_detail_id like '%QST%' then cast(jel.amount as number(20, 2)) - cast(coalesce(itl.qst_value, 0) as number(20, 2))
            when gtd.tax_detail_id like '%HST%' or gtd.tax_detail_id like '%GST%' then cast(jel.amount as number(20, 2)) - cast(coalesce(itl.hst_value, 0) as number(20, 2))
            else cast(jel.amount as number(20, 2))
        end)) as unique_id,
        concat((case when jel.debit_or_credit = 'CR' then 'C' else '' end), left((case when jel.debit_or_credit = 'DR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else (case when jel.debit_or_credit = 'CR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else 'ERROR' end) end), 2), '/', right((case when jel.debit_or_credit = 'DR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else (case when jel.debit_or_credit = 'CR' then (case when ere.payment_type_code = 'CASH' then to_varchar(ere.transaction_date, 'MM-yyyy') else to_varchar(ere.posted_date, 'MM-yyyy') end) else 'ERROR' end) end), 2), ' ', right(erh.report_id, 4), ' ', upper(erh.user_last_name), ',', upper(left(erh.user_first_name, 1))) as docnumbr,
        max(erh.currency_code) as currency,
        max(gtd.tax_detail_id) as taxdetailid,
        sum(abs(case
            when gtd.tax_detail_id like '%PST%' or gtd.tax_detail_id like '%QST%' then cast(coalesce(itl.qst_value, 0) as number(20, 2))
            when gtd.tax_detail_id like '%HST%' or gtd.tax_detail_id like '%GST%' then cast(coalesce(itl.hst_value, 0) as number(20, 2))
            else cast('0' as number(20, 2))
        end))
        +
        sum(case
            when gtd.tax_detail_id like '%PST%' or gtd.tax_detail_id like '%QST%' then cast(jel.amount as number(20, 2)) - cast(coalesce(itl.qst_value, 0) as number(20, 2))
            when gtd.tax_detail_id like '%HST%' or gtd.tax_detail_id like '%GST%' then cast(jel.amount as number(20, 2)) - cast(coalesce(itl.hst_value, 0) as number(20, 2))
            else cast(jel.amount as number(20, 2))
        end) as amount,
        case
            when jel.debit_or_credit = 'DR'
                then {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}

            when jel.debit_or_credit = 'CR'
                then 'C' || {{ concur_r_id('erh.ledger_name', 'erh.report_id', 'ere.payment_type_code', 'ere.transaction_date', 'ere.posted_date', 'ere.payment_type_name', 'erh.currency_code') }}
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

    left join {{ ref("stg_gp__company") }} as ccd
        on ccd.company_code = replace(erh.source_company, '4M#', '4M3')

    left join {{ ref("stg_gp__company") }} as dcd
        on dcd.company_code = itl.company_code

    left join {{ ref('stg_concur__taxes') }} as tax
        on tax.province = 'NB'

    left join {{ ref('stg_gp__tax_account_detail') }} as gtd
        on
            gtd.tax_detail_percent = coalesce(tax.gst, tax.hst, tax.pst, tax.qst)
            and ccd.gp_database = gtd.division

    left join {{ ref('stg_concur__intercompany_accounts') }} as gia
        on gia.gpdatabase = dcd.gp_database

    where
        erh.approval_status_code = 'A_APPR'
        and erh.source_company not in ('OPI', 'OSY', 'OH', 'OFS')
        and ccd.gp_database != 'HSI'

    group by
        erh.report_id,
        erh.paid_date,
        ere.payment_type_code,
        '2',
        '',
        erh.user_first_name,
        erh.user_last_name,
        jel.debit_or_credit,
        ccd.gp_database,
        '',
        '',
        ere.posted_date,
        ere.transaction_date,
        erh.ledger_name,
        ere.payment_type_name,
        erh.currency_code
        -- r_idmonthyear
)

select * from expense
