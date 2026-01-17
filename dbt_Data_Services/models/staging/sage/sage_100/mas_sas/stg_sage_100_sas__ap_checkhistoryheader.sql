with

source as (

    select * from {{ source('mas_sas_dbo', 'ap_checkhistoryheader') }}

),

renamed as (

    select
        bankcode,
        checkno,
        checkseqno,
        clearedbank,
        checkcomment,
        udf_tcambio,
        transferdiscountamt,
        sourcejournal,
        timeupdated,
        apdivisionno,
        cleareddate,
        udf_entrega_a,
        transfervendorno,
        udf_ck_nomctabanca,
        usercreatedkey,
        encryptedvals,
        datecreated,
        udf_ck_comment,
        udf_ck_ctabanco,
        udf_ck_nombanco,
        transferinvoiceno,
        checktype,
        udf_ck_ttransac,
        transferform1099,
        transferapdivisionno,
        checkamt,
        vendorname,
        sourcejournalbatchno,
        achelectronicpayment,
        userupdatedkey,
        vendorno,
        wiretransferno,
        dateupdated,
        transferbox1099,
        checkdate,
        transactiondate,
        timecreated,
        transferinvoicedate,
        achelectronicpaymentamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
