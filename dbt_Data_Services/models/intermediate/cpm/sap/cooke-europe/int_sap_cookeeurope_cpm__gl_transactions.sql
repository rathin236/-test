with generalledger as (

    select * from {{ ref('stg_sap_cookeeurope__factgeneralledger') }}

),

company as (

    select * from {{ ref('stg_sap_cookeeurope__dimcompany') }}

),

currency as (

    select * from {{ ref('stg_sap_cookeeurope__dimcurrency') }}

),

glaccount as (

    select * from {{ ref('stg_sap_cookeeurope__dimglaccount') }}

),

costcenter as (

    select * from {{ ref('stg_sap_cookeeurope__dimcostcenter') }}

),

subledger as (

    select * from {{ ref('int_sap_cookeeurope_cpm__sl_transactions') }}

),

dates as (

    select * from {{ ref('stg_sap_cookeeurope__dimdate') }}

),

beginningbalance as (

    select * from {{ ref('int_sap_cookeeurope_cpm__bb_transactions') }}

),

gltransactions as (

    select
        cmp.companyname as company,
        glr.postingperiod as periodnumber,
        gla.bk_glaccountid as accountnumber,
        gla.glaccountcode as mainaccountnumber,
        ccr.bk_costcenterid as costcentre,
        gla.glaccountname as accountdescription,
        gla.glaccountname as mainaccountdescription,
        ccr.costcentername as costcentredescription,
        glr.amountloccurrency as accountingcurrencyamount,
        glr.amountdoccurrency as transactioncurrencyamount,
        '' as description,
        slr.originatingid,
        slr.originatingname,
        slr.invoicenumber as originatingdocumentnumber,
        cur.bk_currencyid as currency,
        glr.appliedexchangeratelocalcurrency as exchangerate,
        date(dat.datetime) as transactiondate,
        to_varchar(glr.factgeneralledgerid) as journalentrynumber
    from generalledger as glr
    left join company as cmp
        on glr.dimcompanyid = cmp.dimcompanyid
    left join currency as cur
        on glr.dimtransactioncurrencyid = cur.dimcurrencyid
    left join dates as dat
        on glr.dimpostingdateid = dat.dimdateid
    left join glaccount as gla
        on glr.dimglaccountid = gla.dimglaccountid
    left join costcenter as ccr
        on glr.dimcostcenterid = ccr.dimcostcenterid and cmp.bk_companyid = ccr.companycode
    left join subledger as slr
        on glr.dimcompanyid = slr.dimcompanyid and glr.accountdocumentnumber
            = slr.accountdocumentnumber and glr.dimpostingdateid = slr.diminvoicedateid
    where glr.ledger = '0L' and glr.fiscalyear >= '2022'
    order by dat.datetime

),

final as (

    select
        company,
        periodnumber,
        accountnumber,
        mainaccountnumber,
        costcentre,
        accountdescription,
        mainaccountdescription,
        costcentredescription,
        accountingcurrencyamount,
        transactioncurrencyamount,
        description,
        originatingid,
        originatingname,
        originatingdocumentnumber,
        currency,
        exchangerate,
        transactiondate,
        journalentrynumber
    from beginningbalance

    union all

    select
        company,
        periodnumber,
        accountnumber,
        mainaccountnumber,
        costcentre,
        accountdescription,
        mainaccountdescription,
        costcentredescription,
        accountingcurrencyamount,
        transactioncurrencyamount,
        description,
        originatingid,
        originatingname,
        originatingdocumentnumber,
        currency,
        exchangerate,
        transactiondate,
        journalentrynumber
    from gltransactions

)

select * from final
