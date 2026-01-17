with source as (
    select *
    from {{ source('finops_synapse', 'inventbatch') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        pdsinheritbatchattrib,
        pdsinheritedshelflife,
        pdssamelot,
        pdsusevendbatchdate,
        pdsusevendbatchexp,
        sysdatastatecode,
        description,
        expdate,
        itemid,
        pdsbestbeforedate,
        pdscountryoforigin_1,
        pdscountryoforigin_2,
        pdsdispositioncode,
        pdsfinishedgoodsdatetested,
        pdsshelfadvicedate,
        pdsvendbatchdate,
        pdsvendbatchid,
        pdsvendexpirydate,
        proddate,
        manufacturerid,
        originmanufacturerid,
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
        _fivetran_synced,
        upper(inventbatchid) as inventbatchid
    from source
)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
