with customer_address as (
    select
        customersk,
        customeraddresssk,
        lastupdated,
        rank()
            over (partition by customersk order by lastupdated desc)
            as dest_rank
    from {{ ref('stg_northscope__erpx_ar_customer_address') }}

    where
        addresstypeen in (1, 3)
        and addresstypeen != 4
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

        ship.customeraddresssk as sk_shipaddress,
        cust.customerid as customer_id,
        invcust.customername as invoice_customer_name,
        invcust.customerid as invoice_customer_number,
        inv.addressline1 as invoice_address_civic_1,
        inv.addressline2 as invoice_address_civic_2,
        inv.city as invoice_address_city,
        inv.state as invoice_address_state,
        inv.zip as invoice_address_postal_code,
        inv.country as invoice_address_country,
        inv.addressid as invoice_address_name,
        null as longitude,
        null as latitude,
        'CAI_' || trim(ship.customeraddresssk) as key_shipaddress

    from {{ ref('stg_northscope__erpx_ar_customer_address') }} as ship

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as cust
        on ship.customersk = cust.customersk

    left join customer_address_ranked as testres
        on ship.customersk = testres.customersk

    left join {{ ref('stg_northscope__erpx_ar_customer_address') }} as inv
        on testres.customeraddresssk = inv.customeraddresssk

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as invcust
        on inv.customersk = invcust.customersk

    where ship.addresstypeen != 4
)

select * from final
