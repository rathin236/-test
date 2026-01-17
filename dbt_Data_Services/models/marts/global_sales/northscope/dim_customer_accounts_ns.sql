with customer_business_type as (
    select * from {{ ref('int_global_sales_ns__customer_business_type_attribute') }}
),

company as (
    select * from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
),

ship_address as (
    select * from {{ ref('stg_northscope__erpx_ar_customer_address') }}
),

customer as (
    select * from {{ ref('stg_northscope__erpx_ar_customer') }}
),

customer_accounts as (
    select
        ship.customeraddresssk as "Customer_Address_SK",
        row_number() over (partition by ship.customeraddresssk order by ship.customeraddresssk) as dedupe,
        cust.customerid as "Customer ID",
        cust.customername as "Customer Name",
        '' as "Customer Group",
        customer_business_type.customer_business_type as "Customer Business Type",
        null as "Location Alias",
        cust.customername as "Location Name",
        coalesce(ship.addressline1, ship.addressline2) || ', ' || ship.city || ', ' || ship.state || ' ' || ship.zip || ' ' || ship.country as "Address",
        coalesce(ship.addressline1, ship.addressline2) as "Street",
        ship.city as "City",
        ship.zip as "Zip Code",
        ship.state as "State",
        ship.country as "Country",
        null as "Longitude",
        null as "Latitude",
        null as "Valid From",
        null as "Valid To",
        iff(ship.addresstypeen != 4, 1, 0) as "Is Active", -- 1 = Active, 0 = Inactive
        company.companyname

    from ship_address as ship

    left join customer as cust
        on ship.customersk = cust.customersk

    left join customer_business_type
        on cust.customerid = customer_business_type.customerid
    
    left join company 
        on cust.dataentitycompanysk = company.dataentitycompanysk

    order by ship.customeraddresssk
)

select * exclude dedupe from customer_accounts
where dedupe = 1

/* For Testing */
-- where "Customer_Address_SK" = 4755
