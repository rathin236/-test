with source as (
    select *
    from {{ source('finops_synapse', 'dimensionattributevalue') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        isblockedformanualentry,
        isdeleted,
        issuspended,
        istotal,
        pendingsuccessfuldeletevalidation,
        isbalancing_psn,
        sysdatastatecode,
        activefrom,
        activeto,
        cacheddisplayvalue,
        dimensionattribute,
        entityinstance,
        groupdimension,
        hashkey,
        cachedinvariantname,
        cachedname,
        displayvalue,
        backingrecorddataareaid,
        originalentityinstance,
        owner,
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
