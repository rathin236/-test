with vend_trans as (
    select

        vta.dataareaid,
        vta.voucher,
        vta.accountnum,
        vta.currencycode,
        vta.invoice,
        vta.documentdate,
        vto.duedate,
        vta.transdate,
        vta.transtype,
        vta.lastsettledate,
        to_varchar(coalesce(vto.amountcur, 0), 'FM999999999999.00') as amountcur

    from
        {{ ref('stg_d365__vend_trans') }} as vta

    left join
        {{ ref('stg_d365__vend_trans_open') }} as vto
        on
            vta.recid = vto.refrecid

    /*
    where
        vt.VOUCHER = 'API00034512'
    */

    order by vta.voucher

)

select * from vend_trans
