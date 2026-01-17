with cust_table as (
    select * from {{ ref('stg_d365__cust_table') }}
),

dir_party_table as (
    select * from {{ ref('stg_d365__dir_party_table') }}
),

dir_party_postal_address as (
    select * from {{ ref('int_d365__dir_party_postal_address') }}
),

company as (
    select * from {{ ref('int_global_ap__d365_companies') }}
),

dim_customer_accounts as (
    select
        null as "Customer_Address_SK",
        row_number() over (partition by cust.accountnum order by dppa.validfrom desc) as dedupe,
        cust.accountnum as "Customer ID",
        dpt.name as "Customer Name",
        cust.custgroup as "Customer Group",
        cust.segmentid as "Customer Business Type",
        dpt.namesalias as "Location Alias",
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
        dpt.isactive as "Is Active",
        company.company_name

    from cust_table as cust

    left join dir_party_table as dpt
        on cust.party = dpt.recid

    left join dir_party_postal_address as dppa
        on dpt.location = dppa.location

    left join company
    on upper(cust.dataareaid) = company.interid

    order by cust.accountnum
)

select * exclude dedupe from dim_customer_accounts
where dedupe = 1
