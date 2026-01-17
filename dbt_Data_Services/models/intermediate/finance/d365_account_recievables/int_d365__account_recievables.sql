with
    data_area as (select * from {{ ref("stg_d365__data_area") }}),

    cust_trans as (select * from {{ ref("stg_d365__cust_trans") }}),

    custaccount as (select * from {{ ref('stg_d365__cust_table') }}),

    transformeddata as (
        select
            cust_trans.recid,
            cust_trans.dataareaid,
            cust_trans.accountnum,
            cust_trans.amountcur,
            cust_trans.amountmst,
            cust_trans.closed,
            cust_trans.currencycode,
            cust_trans.custexchadjustmentrealized,
            cust_trans.custexchadjustmentunrealized,
            cust_trans.transdate,
            cust_trans.documentdate,
            cust_trans.duedate,
            cust_trans.voucher,
            cust_trans.transtype,
            case
                when
                    to_date(to_varchar(cust_trans.closed, 'MM/DD/YYYY'), 'MM/DD/YYYY')
                    <> '01/01/1900'
                then 'Closed'
                else 'Open'
            end as trans_status,
            case
                when cust_trans.transtype = 2
                then
                    (
                        case
                            when
                                to_date(to_varchar(cust_trans.closed, 'MM/DD/YYYY'), 'MM/DD/YYYY')
                                = '01/01/1900'
                            then datediff(day, cust_trans.transdate, current_date())
                            else datediff(day, cust_trans.transdate, cust_trans.closed)
                        end
                    )
                when cust_trans.transtype <> 2
                then 0
            end as days_outstanding,
            case
                when cust_trans.documentdate = '01/01/1900' then cust_trans.transdate else cust_trans.documentdate
            end as documenttransdate,
            case
                substring(cust_trans.voucher, 1, 3)
                when 'CIV' then 'Sales'
                when 'FTI' then 'Sales'
                when 'ARP' then 'Collections'
                when 'CNV' then 'Credits'
                when 'FTC' then 'Credits'
                when 'GLJ' then
                    case when cust_trans.amountcur < 0 then 'Credits' else 'Sales' end
                else 'JE'
            end as document_group,
            substring(cust_trans.voucher, 1, 3) as voucher_type
        from cust_trans
        left join custaccount as cust on cust_trans.accountnum = cust.accountnum
       where cust.custgroup like '%AR-TRADE%'
    )

select *
from transformeddata
