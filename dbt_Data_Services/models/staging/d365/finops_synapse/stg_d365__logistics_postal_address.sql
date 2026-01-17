with

source as (

    select * from {{ source('finops_synapse', 'logisticspostaladdress') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        isprivate,
        timezone,
        issimplifiedaddress_ru,
        sysdatastatecode,
        address,
        apartment_ru,
        building_ru,
        buildingcompliment,
        city,
        cityrecid,
        countryregionid,
        county,
        district,
        districtname,
        flatid_ru,
        houseid_ru,
        latitude,
        location,
        longitude,
        postbox,
        privateforparty,
        state,
        street,
        streetid_ru,
        streetnumber,
        validfrom,
        validto,
        zipcode,
        zipcoderecid,
        citykana_jp,
        streetkana_jp,
        steadid_ru,
        channelreferenceid,
        settlementrecid,
        localityrecid,
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
