with beginningbalances as (

    select * from {{ ref('stg_sap_sladegorton__glt0') }}

),

companymaster as (

    select * from {{ ref('stg_sap_sladegorton__t001') }}

),

glaccount_master as (

    select * from {{ ref('stg_sap_sladegorton__skat') }}

),

-- costcentre_master as (

--     select * from {{ ref('stg_sap_sladegorton__cskt') }}

-- ),

beginningbalance as (

    select

        bukrs,
        racct,
        rclnt,
        ryear,
        rtcur,
        sum(tslvt) as tslvt,
        sum(hslvt) as hslvt

    from beginningbalances
    group by bukrs, racct, rclnt, ryear, rtcur

),

joined as (

    select

        cma.butxt as company,
        '00' as periodnumber,
        bba.racct as mainaccountnumber,
        '' as costcenter,
        glm.txt50 as mainaccountdescription,
        null as costcenterdescription,
        null as originatingmasterid,
        null as originatingmastername,
        null as originatingdocumentnumber,
        bba.rtcur as currency,
        null as volumelbssold,
        null as lineofbusiness,
        date(concat(bba.ryear, '-01-01')) as transactiondate,
        concat('BB-', bba.ryear) as documentnumber,
        to_decimal(bba.hslvt, 10, 2) as amountaccountingcurrency,
        to_decimal(bba.tslvt, 10, 2) as amounttransactioncurrency,
        concat('Beginning Balance ', bba.ryear) as transactiondescription,
        case
            when bba.rtcur != 'USD' and bba.hslvt != 0 and bba.tslvt != 0 then round(bba.hslvt / bba.tslvt, 6)
            else 1
        end as exchangerate

    from beginningbalance as bba
    left join companymaster as cma
        on bba.bukrs = cma.bukrs
    left join glaccount_master as glm
        on bba.racct = glm.saknr and cma.ktopl = glm.ktopl and bba.rclnt = glm.mandt
    where bba.ryear >= '2022'
    order by bba.ryear

)

select * from joined
where amountaccountingcurrency != 0 or amounttransactioncurrency != 0
