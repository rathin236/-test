with invent_site as (
    select * from {{ ref('stg_d365__invent_site') }}
),

invent_site_logistics_location as (
    select * from {{ ref('stg_d365__invent_site_logistics_location') }}
),

logistics_postal_address_view as (
    select * from {{ ref('int_d365__logistics_postal_address_view') }}
),

dim_site as (
    select

        invs.siteid as "Site_SK",
        invs.name as "Site Name",
        invs.siteid as "Site ID",
        null as "Site Registration Code",
        lpav.address as "Address",
        lpav.street as "Street",
        lpav.city as "City",
        lpav.state as "State",
        lpav.zipcode as "Postal Code",
        lpav.isocode as "Country"

    from invent_site as invs

    inner join invent_site_logistics_location as isll
        on invs.recid = isll.site

    inner join logistics_postal_address_view as lpav
        on isll.location = lpav.location

    qualify row_number() over (partition by invs.recid order by invs.siteid) = 1

    order by invs.siteid
)

select * from dim_site
