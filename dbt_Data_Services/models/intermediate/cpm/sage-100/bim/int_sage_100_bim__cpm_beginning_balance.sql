with account_master as (

    select * from {{ ref('int_sage_100_bim__account_master') }}

),

beginning_balance as (

    select * from {{ ref('stg_sage_100_bim__gl_periodpostinghistory') }}
    where fiscalperiod = 1

),

joined as (

    select

        ama.companycode,
        bbal.fiscalyear,
        ama.account,
        ama.mainaccountcode,
        ama.segment_02,
        ama.segment_03,
        ama.accountdesc,
        ama.segment_02_desc,
        ama.segment_03_desc,
        bbal.beginningbalance

    from beginning_balance as bbal
    left outer join account_master as ama
        on bbal.accountkey = ama.accountkey

),

transformed as (

    select

        companycode as company,
        '00' as period,
        account as account_number,
        mainaccountcode as main_account_number,
        segment_02 as sub_account,
        segment_03 as detail,
        accountdesc as account_description,
        segment_02_desc as sub_account_description,
        segment_03_desc as detail_description,
        '' as originating_document_number,
        '' as originating_id,
        '' as originating_name,
        date(concat(fiscalyear, '-01-01')) as transaction_date,
        concat('BBF-', fiscalyear) as journal_entry_number,
        case when beginningbalance > 0 then beginningbalance else 0 end as debitamount,
        case when beginningbalance < 0 then beginningbalance * -1 else 0 end as creditamount,
        concat('Beginning Balance ', fiscalyear) as postingcomment

    from joined

)

select * from transformed
