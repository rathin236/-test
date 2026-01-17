with
source as (
    select * from {{ source("finops_synapse", "generaljournalaccountentry") }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        iscorrection,
        iscredit,
        postingtype,
        skipcreditcalculation,
        assetleasepostingtypes,
        assetleasetransactiontype,
        sysdatastatecode,
        accountingcurrencyamount,
        allocationlevel,
        generaljournalentry,
        historicalexchangeratedate,
        ledgeraccount,
        ledgerdimension,
        quantity,
        reportingcurrencyamount,
        subledgerjournalentry,
        text,
        transactioncurrencyamount,
        transactioncurrencycode,
        mainaccount,
        fintag,
        projid_sa,
        projtabledataareaid,
        reasonref,
        paymentreference,
        originalaccountentry,
        modifieddatetime,
        modifiedby,
        modifiedtransactionid,
        createddatetime,
        createdby,
        createdtransactionid,
        dataareaid,
        recversion,
        partition,
        sysrowversion,
        recid,
        tableid,
        versionnumber,
        createdon,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced
    from source
)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
