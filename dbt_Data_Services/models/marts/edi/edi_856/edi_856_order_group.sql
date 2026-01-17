with order_group as (
    select

        soh.purchaseorder as po_number,
        soc.carriercode as scac,
        'IT' as ref_num_qual, -- Jeff Carletons note from 2020: Definitely need more clarification on this, this is also in a sub section called "Reference"
        soh.orderid as order_id,
        to_date(soh.orderdate) as po_date

    from {{ ref('stg_northscope__erpx_so_order_header') }} as soh

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on caa.customeraddresssk = soh.shipaddresssk
            and caa.dataentitycompanysk = soh.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    inner join {{ ref('stg_northscope__erpx_so_carrier') }} as soc
        on soh.dataentitycompanysk = soc.dataentitycompanysk
            and soh.carriersk = soc.carriersk

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue
)

select * from order_group

/* For Testing */
-- where order_id = 'AFO026562'
