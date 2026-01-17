with logistics_postal_address as (
    select * from {{ ref('stg_d365__logistics_postal_address') }}
),

logistics_location as (
    select * from {{ ref('stg_d365__logistics_location') }}
),

logistics_address_country_region as (
    select * from {{ ref('stg_d365__logistics_address_country_region') }}
),

logistics_postal_address_view as (
    select

        lpa.county,
        lpa.district,
        lpa.address,
        lpa.city,
        lpa.countryregionid,
        lpa.latitude,
        lpa.state,
        lpa.street,
        lpa.streetnumber,
        lpa.timezone,
        lpa.longitude,
        lpa.zipcode,
        lpa.location,
        lpa.validfrom,
        lpa.validto,
        lpa.recid as postal_address_rec_id,
        lpa.recid as postal_address,
        lpa.districtname,
        lpa.flatid_ru,
        lpa.houseid_ru,
        lpa.streetid_ru,
        lpa.isprivate,
        lpa.privateforparty,
        lpa.recid as x_rec_id_logistics_postal_address,
        lpa.recversion as x_rec_version_logistics_postal_address,
        lpa.cityrecid,
        lpa.partition,
        lpa.recid,
        lacr.partition as partition_2,
        logl.description as location_name,
        logl.partition as partition_3

    from logistics_postal_address as lpa

    cross join logistics_address_country_region as lacr

    cross join logistics_location as logl

    where lpa.countryregionid = lacr.countryregionid
        and lpa.partition = lacr.partition
        and lpa.location = logl.recid
        and lpa.partition = logl.partition

),

dir_party_postal_address as (
    select

        dpl.party,
        dpl.recid as party_location,
        dpl.isprimary,
        dpl.islocationowner,
        dpl.isprimarytaxregistration,
        dpl.recid as table_rec_id,
        dpl.partition,
        dpl.recid,
        lpav.location_name,
        lpav.address,
        lpav.streetnumber,
        lpav.street,
        lpav.city,
        lpav.zipcode,
        lpav.state,
        lpav.county,
        lpav.countryregionid,
        lpav.district,
        lpav.timezone,
        lpav.longitude,
        lpav.latitude,
        lpav.location,
        lpav.validfrom,
        lpav.validto,
        lpav.isprivate,
        lpav.districtname,
        lpav.postal_address,
        lpav.streetid_ru,
        lpav.houseid_ru,
        lpav.flatid_ru,
        lpav.privateforparty,
        lpav.x_rec_id_logistics_postal_address,
        lpav.x_rec_version_logistics_postal_address,
        lpav.cityrecid,
        lpav.partition as partition_2

    from {{ ref('stg_d365__dir_party_location') }} as dpl

    left outer join logistics_postal_address_view as lpav
        on dpl.location = lpav.location
            and dpl.partition = lpav.partition

    -- where dpl.ispostaladdress = 1

)

select * from dir_party_postal_address
