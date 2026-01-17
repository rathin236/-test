with dir_party_postal_address as (
    select * from {{ ref('int_d365__dir_party_postal_address') }}
),

dim_delivery_address as (
    select

        postal_address as "Postal Address",
        location_name as "Address Name",
        address as "Address",
        street as "Street",
        city as "City",
        state as "State",
        zipcode as "Zip Code",
        county as "County",
        countryregionid as "Country",
        latitude as "Latitude",
        longitude as "Longitude"

    from dir_party_postal_address

    where postal_address is not null

    qualify row_number() over (partition by postal_address order by postal_address) = 1

    order by postal_address
)

select * from dim_delivery_address
