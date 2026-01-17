{{ config(materialized='view') }}

with source as (
    select *
    from {{ source('finops_synapse', 'inventtablemodule') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        allocatemarkup,
        enddisc,
        intercompanyblocked,
        moduletype,
        taxwithholdcalculate_th,
        basepricepurchase,
        sysdatastatecode,
        itemid,
        linedisc,
        markup,
        markupgroupid,
        markupseccur_ru,
        maximumretailprice_in,
        multilinedisc,
        overdeliverypct,
        pdspricingprecision,
        price,
        pricedate,
        priceqty,
        priceseccur_ru,
        priceunit,
        suppitemgroupid,
        taxitemgroupid,
        taxwithholditemgroupheading_th,
        underdeliverypct,
        unitid,
        taxgstreliefcategory_my,
        emptystring,
        retailinventoryavailabilitybuffer,
        retailinventoryavailabilitylevelprofile,
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
