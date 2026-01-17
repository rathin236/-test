with source as (
    select *
    from {{ source('finops_synapse', 'exchangeratecurrencypair') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        exchangeratedisplayfactor,
        sysdatastatecode,
        exchangeratetype,
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
        upper(fromcurrencycode) as fromcurrencycode,
        upper(tocurrencycode) as tocurrencycode
    from source
)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
