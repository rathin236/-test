with source as (
    select *
    from {{ source('finops_synapse', 'docuref') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        intercompanyskipupdate,
        restriction,
        defaultattachment,
        isjustification,
        smmtable,
        isglobalattachment_dc,
        sysdatastatecode,
        refcompanyid,
        actualcompanyid,
        author,
        name,
        notes,
        party,
        refrecid,
        reftableid,
        typeid,
        valuerecid,
        documentid,
        contactpersonid,
        smmemailentryid,
        smmemailstoreid,
        encyclopediaitemid,
        languageid_dc,
        categoryid_dc,
        tags_dc,
        activefrom_dc,
        activeto_dc,
        engchgengineeringreference,
        engchgengineeringdocument,
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
