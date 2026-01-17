with

source as (

    select * from {{ source('finops_synapse', 'logisticsaddresscountryregion') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        addressusezipplus_4,
        isimmutable,
        timezone,
        memberofcustomsunion_ru,
        sysdatastatecode,
        addrformat,
        bacencode_br,
        countryregionid,
        currencycode,
        isocode,
        oksmcode_ru,
        mcrior_facility_id,
        rpayparentcountryregionid,
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
