with cust_trans as (
    select

        cta.dataareaid,
        cta.voucher,
        cta.accountnum,
        cta.currencycode,
        cta.invoice,
        cta.documentdate,
        cto.duedate,
        cta.transdate,
        cta.transtype,
        cta.lastsettledate,
        to_varchar(coalesce(cto.amountcur, 0), 'FM999999999999.00') as amountcur

    from
        {{ ref('stg_d365__cust_trans') }} as cta

    left join
        {{ ref('stg_d365__cust_trans_open') }} as cto
        on
            cta.recid = cto.refrecid

    order by cta.voucher

)

select * from cust_trans
