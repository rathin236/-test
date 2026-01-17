with customer_address as (
    select
        customersk,
        customeraddresssk,
        lastupdated,
        rank() over (partition by customersk order by lastupdated desc) as dest_rank
    from {{ ref('stg_northscope__erpx_ar_customer_address') }}

    where addresstypeen in (1, 3)
        and addresstypeen != 4
),

customer_business_type as (
    select * from {{ ref('int_global_sales_ns__customer_business_type_attribute') }}
),

customer_address_ranked as (
    select

        customersk,
        customeraddresssk,
        lastupdated

    from customer_address

    where dest_rank = 1
),

final as (
    select

        ship.customeraddresssk as "Customer_Address_SK",
        row_number() over (partition by ship.customeraddresssk order by ship.customeraddresssk) as dedupe,
        cust.customerid as "Customer ID",
        invcust.customername as "Customer Name",
        customer_business_type.customer_business_type as "Customer Business Type",
        coalesce(inv.addressline1, inv.addressline1) as "Location",
        invcust.customername as "Location Name",
        inv.addressline1 || ' ' || inv.addressline2 || ' ' || inv.city || ', ' || inv.state || ' ' || inv.zip || ' ' || inv.country as "Address",
        coalesce(inv.addressline1, inv.addressline1) as "Street",
        inv.city as "City",
        inv.zip as "Zip Code",
        inv.state as "State",
        inv.country as "Country",
        null as longitude,
        null as latitude,
        null as "Valid From",
        null as "Valid To",
        iff(ship.addresstypeen != 4, 1, 0) as "Is Active" -- 1 = Active, 0 = Inactive

    from {{ ref('stg_northscope__erpx_ar_customer_address') }} as ship

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as cust
        on ship.customersk = cust.customersk

    left join customer_address_ranked as testres
        on ship.customersk = testres.customersk

    left join {{ ref('stg_northscope__erpx_ar_customer_address') }} as inv
        on testres.customeraddresssk = inv.customeraddresssk

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as invcust
        on inv.customersk = invcust.customersk

    left join customer_business_type
        on cust.customerid = customer_business_type.customerid

    order by ship.customeraddresssk
)

select * exclude dedupe from final
where dedupe = 1
