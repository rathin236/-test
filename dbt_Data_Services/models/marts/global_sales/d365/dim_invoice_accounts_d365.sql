with cust_table as (
    select * from {{ ref('stg_d365__cust_table') }}
),

dir_party_table as (
    select * from {{ ref('stg_d365__dir_party_table') }}
),

dir_party_postal_address as (
    select * from {{ ref('int_d365__dir_party_postal_address') }}
),

dim_invoice_account as (
    select

        cust.accountnum as "Invoice ID",
        row_number() over (partition by cust.accountnum order by dppa.validfrom desc) as dedupe,
        dpt.name as "Customer Name",
        cust.segmentid as "Customer Business Type",
        dpt.namesalias as "Location",
        dppa.location_name as "Location Name",
        dppa.address as "Address",
        dppa.street as "Street",
        dppa.city as "City",
        dppa.zipcode as "Zip Code",
        dppa.state as "State",
        dppa.countryregionid as "Country",
        dppa.longitude as "Longitude",
        dppa.latitude as "Latitude",
        dppa.validfrom as "Valid From",
        dppa.validto as "Valid To",
        dpt.isactive as "Is Active"

    from cust_table as cust

    inner join dir_party_table as dpt
        on cust.party = dpt.recid

    inner join dir_party_postal_address as dppa
        on dpt.location = dppa.location

    order by cust.accountnum

)

select * exclude dedupe from dim_invoice_account
where dedupe = 1
