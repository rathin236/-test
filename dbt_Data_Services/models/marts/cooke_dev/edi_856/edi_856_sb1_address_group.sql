with address_group as (
    select

        'ST' as entity_id_code,
        cus.customerid as edi_bill_to_id_code,
        cusad.addressid as accounting_id_code,
        cusad.addressname as name_,
        cusad.addressline1 as address_1,
        cusad.addressline2 as address_2,
        cusad.city,
        cusad.state,
        cusad.zip,
        cusad.phone1 as contact_phone,
        cusad.fax as phone_fax,
        cusad.country,
        soh.orderid as order_id,
        md5(soh.orderid::string || cusad.addressid::string) as incremental_uid

    from {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk
            and soh.dataentitycompanysk = cus.dataentitycompanysk

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address') }} as cusad
        on soh.shipaddresssk = cusad.customeraddresssk
            and soh.dataentitycompanysk = cusad.dataentitycompanysk

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caa
        on caa.customeraddresssk = soh.shipaddresssk
            and caa.dataentitycompanysk = soh.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue
)

select * from address_group

/* For Testing */
-- where order_id = 'AFO026562'
