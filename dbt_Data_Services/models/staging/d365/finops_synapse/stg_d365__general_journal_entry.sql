with
source as (
    select *
    from {{ source("finops_synapse", "generaljournalentry") }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        journalcategory,
        postinglayer,
        sysdatastatecode,
        accountingdate,
        acknowledgementdate,
        documentdate,
        documentnumber,
        fiscalcalendarperiod,
        fiscalcalendaryear,
        journalnumber,
        ledger,
        subledgerjournalentry,
        transferid,
        subledgervoucher,
        subledgervoucherdataareaid,
        ledgerentryjournal,
        ledgerpostingjournal,
        ledgerpostingjournaldataareaid,
        budgetsourceledgerentryposted,
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
