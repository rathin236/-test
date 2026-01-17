with

source as (

    select * from {{ source('finops_synapse', 'inventitemgroupitem') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        sysdatastatecode,
        itemdataareaid,
        itemgroupdataareaid,
        itemgroupid,
        itemid,
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
