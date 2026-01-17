with logistics_postal_address as (
    select * from {{ ref('stg_d365__logistics_postal_address') }}
),

logistics_address_country_region as (
    select * from {{ ref('stg_d365__logistics_address_country_region') }}
),

logistics_location as (
    select * from {{ ref('stg_d365__logistics_location') }}
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
        lpa.recid as postaladdressrecid,
        lpa.recid as postaladdress,
        lpa.districtname,
        lpa.flatid_ru,
        lpa.houseid_ru,
        lpa.streetid_ru,
        lpa.isprivate,
        lpa.privateforparty,
        lpa.recid as xrecid_logisticspostaladdress,
        lpa.recversion as xrecversion_logisticspostaladdress,
        lpa.cityrecid,
        lpa.partition as partition_,
        lpa.recid,
        lacr.isocode,
        lacr.partition as partition2,
        logl.description as locationname,
        logl.partition as partition3

    from logistics_postal_address as lpa

    cross join logistics_address_country_region as lacr

    cross join logistics_location as logl

    where
        lpa.countryregionid = lacr.countryregionid
        and lpa.partition = lacr.partition
        and lpa.location = logl.recid
        and lpa.partition = logl.partition
)

select * from logistics_postal_address_view
