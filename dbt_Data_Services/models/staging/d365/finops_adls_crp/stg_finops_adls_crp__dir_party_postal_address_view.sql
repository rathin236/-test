with

source as (

    select * from {{ source('finops_adls_crp', 'dir_party_postal_address_view') }}

),

renamed as (

    select
        party,
        partylocation,
        isprimary,
        islocationowner,
        isprimarytaxregistration,
        tablerecid,
        partition,
        recid,
        locationname,
        address,
        streetnumber,
        street,
        city,
        zipcode,
        state,
        county,
        countryregionid,
        district,
        timezone,
        longitude,
        latitude,
        location,
        validfrom,
        validto,
        isprivate,
        districtname,
        postaladdress,
        isocode,
        streetid_ru,
        houseid_ru,
        flatid_ru,
        privateforparty,
        xrecid_logisticspostaladdress,
        xrecversion_logisticspostaladdress,
        cityrecid,
        partition2

    from source

)

select * from renamed
