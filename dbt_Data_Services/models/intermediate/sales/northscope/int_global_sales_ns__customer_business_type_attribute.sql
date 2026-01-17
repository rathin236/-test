with customer_business_type as (
    select
        cast(attributevaluesk as varchar) as attributevaluesk,
        attributevalue,
        dataentitycompanysk

    from {{ ref('stg_northscope__erpx_mf_attribute_value') }}

    where attributesk in (
            select attributesk from {{ ref('stg_northscope__erpx_mf_attribute') }}
            where attribute ilike '%Customer Business Type%'
        )
),

customers_with_cust_business_type as (
    select
        customer_business_type.attributevalue as customer_business_type,
        customer_business_type.dataentitycompanysk,
        customer_attribute.customersk,
        customer_attribute.customerattributesk

    from
        {{ ref('stg_northscope__erpx_ar_customer_attribute') }}
            as customer_attribute

    inner join customer_business_type
        on
            customer_attribute.attributevalue
            = customer_business_type.attributevaluesk
            and customer_attribute.dataentitycompanysk
            = customer_business_type.dataentitycompanysk
)

select
    customers_with_cust_business_type.customer_business_type,
    customers_with_cust_business_type.dataentitycompanysk,
    ar_customer.customerid
from customers_with_cust_business_type

inner join {{ ref('stg_northscope__erpx_ar_customer') }} as ar_customer
    on
        customers_with_cust_business_type.customersk = ar_customer.customersk
        and customers_with_cust_business_type.dataentitycompanysk
        = ar_customer.dataentitycompanysk
