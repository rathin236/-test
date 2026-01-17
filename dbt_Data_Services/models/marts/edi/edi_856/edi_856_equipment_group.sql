with equipment_group as (
    select distinct

        orderid as order_id,
        'TL' as equipment_desc_code

    from {{ ref('stg_northscope__erpx_so_order_header') }}

    where dataentitycompanysk = 1 --TNS

)

select * from equipment_group

/* For Testing */
-- where order_id = 'AFO026562'
