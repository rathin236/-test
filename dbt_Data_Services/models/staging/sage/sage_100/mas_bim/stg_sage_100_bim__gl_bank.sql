with

source as (

    select * from {{ source('mas_bim_dbo', 'gl_bank') }}

),

renamed as (

    select
        bankcode,
        bankaccountno,
        statementbalance,
        bankcloudlastdownloadtime,
        currentbankbalance,
        nextcheckno,
        initialnextpayrollcheckno,
        startingpayrollcheckno,
        bankcloudlasttransactionid,
        nooutstandingdeposits,
        outstandingadjusttotal,
        checkprintingstatus,
        outstandingdeposittotal,
        bankdesc,
        encryptedvals,
        bankcloudlastdownloaddate,
        bankcloudaccountid,
        numberoutstandingadjust,
        nextpayrollcheckno,
        outstandingchecktotal,
        numberoutstandingchecks,
        cashaccountkey,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
