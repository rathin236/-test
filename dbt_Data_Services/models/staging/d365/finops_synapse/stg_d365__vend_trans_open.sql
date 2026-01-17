{{ config(materialized='view') }}

with source as (
    select *
    from {{ source('finops_synapse', 'vendtransopen') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        settlement_in,
        taxwithholdstatus_in,
        usecashdisc,
        taxdistribution,
        sysdatastatecode,
        accountnum,
        amountcur,
        amountmst,
        bankdiscnoticedeadline,
        banklcimportline,
        cashdiscdate,
        cashdiscountledgerdimension,
        duedate,
        epbarcodeinfo_br,
        exchadjunrealized,
        exchadjunrealizedreporting,
        fineamount_br,
        fineamountpaymcur_br,
        finecode_br,
        gtarecoverableamount_in,
        interestamount_br,
        interestamountpaymcur_br,
        interestcode_br,
        lastinterestdatedummy,
        possiblecashdisc,
        refrecid,
        reportingcurrencyamount,
        tax_1099_amount,
        tax_1099_stateamount,
        taxcomponenttable_in,
        taxwithholdamountorigin_in,
        taxwithholdregnumber_in,
        tcsamount_in,
        tdsamount_in,
        thirdpartybankaccountid,
        transdate,
        covstatus,
        ltmexchrate,
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
