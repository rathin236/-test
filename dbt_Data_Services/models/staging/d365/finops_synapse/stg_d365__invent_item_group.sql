with

source as (

    select * from {{ source('finops_synapse', 'inventitemgroup') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        assetgroup_in,
        revrecexcludefromcarveout,
        revrecmedianprice,
        revrecrevenuerecognitionenabled,
        revrecrevenuetype,
        sysdatastatecode,
        taxitemgroupidsales,
        duedatelimitgroupid_es,
        itemgroupid,
        loadtemplateid,
        name,
        standarditemallocateid,
        taxitemgroupidpurch,
        retailsaftstandardvatcode,
        revrecdefaultrevenuerecognitionschedule,
        revrecmedianpricemaximumtolerance,
        revrecmedianpriceminimumtolerance,
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
