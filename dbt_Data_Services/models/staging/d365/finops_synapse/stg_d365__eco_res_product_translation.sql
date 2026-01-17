with

source as (

    select * from {{ source('finops_synapse', 'ecoresproducttranslation') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        sysdatastatecode,
        description,
        languageid,
        name,
        product,
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
