with beginningbalance as (

    select
rbukrs,
ryear,
rldnr,
racct,
rcntr,
rtcur,
sum(hslvt) as hslvt,
sum(tslvt) as tslvt
    from {{ ref('stg_sap_cookeeurope__faglflext') }}
    group by rbukrs, ryear, rldnr, racct, rcntr, rtcur

),

company as (

    select * from {{ ref('stg_sap_cookeeurope__dimcompany') }}

),

glaccount as (

    select * from {{ ref('stg_sap_cookeeurope__dimglaccount') }}

),

costcenter as (

    select * from {{ ref('stg_sap_cookeeurope__dimcostcenter') }}

),

final as (

    select
        c.companyname as company,
        '000' as periodnumber,
        bb.racct as accountnumber,
        gla.glaccountcode as mainaccountnumber,
        cc.bk_costcenterid as costcentre,
        gla.glaccountname as accountdescription,
        gla.glaccountname as mainaccountdescription,
        cc.costcentername as costcentredescription,
        bb.hslvt as accountingcurrencyamount,
        bb.tslvt as transactioncurrencyamount,
        '' as description,
        null as originatingid,
        null as originatingname,
        null as originatingdocumentnumber,
        bb.rtcur as currency,
        date(concat(bb.ryear, '-01-01')) as transactiondate,
        concat('BB-', bb.ryear) as journalentrynumber,
        case
            when bb.rtcur = 'EUR' then 1
            when bb.hslvt = 0 or bb.tslvt = 0 then 1
            else (bb.hslvt / bb.tslvt)
        end as exchangerate
    from beginningbalance as bb
    left join company as c
        on bb.rbukrs = c.bk_companyid
    left join glaccount as gla
        on bb.racct = gla.bk_glaccountid
    left join costcenter as cc
        on bb.rcntr = cc.bk_costcenterid and bb.rbukrs = cc.companycode
    where bb.rldnr = '0L' and bb.ryear >= '2022'
    order by bb.ryear

)

select * from final
