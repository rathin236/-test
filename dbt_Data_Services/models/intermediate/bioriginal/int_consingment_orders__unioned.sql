-- create list of consingment orders for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_wh as (

    select

        order_number,
        line_number,
        sequence_number,
        warehouse_number,
        purchase_order_number,
        purchase_order_line,
        quantity

    from {{ ref("stg_infor_ln__bioriginal_north_america_consingment_orders") }}

),

eu_wh as (

    select

        order_number,
        line_number,
        sequence_number,
        warehouse_number,
        purchase_order_number,
        purchase_order_line,
        quantity

    from {{ ref("stg_infor_ln__bioriginal_europe_consingment_orders") }}
),

asia_wh as (

    select

        order_number,
        line_number,
        sequence_number,
        warehouse_number,
        purchase_order_number,
        purchase_order_line,
        quantity

    from {{ ref("stg_infor_ln__bioriginal_asia_consingment_orders") }}

),

warehouses_unioned as (

    select * from na_wh
    union all
    select * from eu_wh
    union all
    select * from asia_wh

),

na_wt as (

    select

        warehouse_number,
        whs_type

    from {{ ref("stg_infor_ln__bioriginal_north_america_warehouses") }}

),

eu_wt as (

    select

        warehouse_number,
        whs_type

    from {{ ref("stg_infor_ln__bioriginal_europe_warehouses") }}
),

asia_wt as (

    select

        warehouse_number,
        whs_type

    from {{ ref("stg_infor_ln__bioriginal_asia_warehouses") }}

),

types_unioned as (

    select * from na_wt
    union all
    select * from eu_wt
    union all
    select * from asia_wt

),

wh_joined as (

    select

        whu.order_number,
        whu.line_number,
        whu.sequence_number,
        whu.purchase_order_number,
        whu.purchase_order_line,
        whu.quantity,
        whu.warehouse_number,
        tyu.whs_type

    from warehouses_unioned as whu
    left outer join types_unioned as tyu on whu.warehouse_number = tyu.warehouse_number

),

na_po as (

    select

        purchase_order_currency,
        purchase_order_number

    from {{ ref("stg_infor_ln__bioriginal_north_america_purchase_orders") }}

),

eu_po as (

    select

        purchase_order_currency,
        purchase_order_number

    from {{ ref("stg_infor_ln__bioriginal_europe_purchase_orders") }}

),

asia_po as (

    select

        purchase_order_currency,
        purchase_order_number

    from {{ ref("stg_infor_ln__bioriginal_asia_purchase_orders") }}

),

unioned_pos as (

    select * from na_po
    union all
    select * from eu_po
    union all
    select * from asia_po

),

pos_joined as (

    select

        whj.order_number,
        whj.line_number,
        whj.sequence_number,
        whj.purchase_order_number,
        whj.purchase_order_line,
        whj.quantity,
        whj.warehouse_number,
        whj.whs_type,
        upo.purchase_order_currency

    from wh_joined as whj
    left outer join unioned_pos as upo on whj.purchase_order_number = upo.purchase_order_number

),

na_po_amount as (

    select

        purchase_order_number,
        purchase_order_line,
        price,
        discount

    from {{ ref("stg_infor_ln__bioriginal_north_america_purchase_order_amounts") }}

),

eu_po_amount as (

    select

        purchase_order_number,
        purchase_order_line,
        price,
        discount

    from {{ ref("stg_infor_ln__bioriginal_europe_purchase_order_amounts") }}

),

asia_po_amount as (

    select

        purchase_order_number,
        purchase_order_line,
        price,
        discount

    from {{ ref("stg_infor_ln__bioriginal_asia_purchase_order_amounts") }}

),

po_amount_unioned as (

    select * from na_po_amount
    union all
    select * from eu_po_amount
    union all
    select * from asia_po_amount

),

po_amount_joined as (

    select

        poj.order_number,
        poj.line_number,
        poj.sequence_number,
        poj.purchase_order_number,
        poj.purchase_order_line,
        poj.warehouse_number,
        poj.whs_type,
        poj.purchase_order_currency,
        pau.price,
        pau.discount,
        poj.quantity,
        round(((pau.price - ((pau.discount / 100) * pau.price)) * poj.quantity), 2) as purchase_order_amount

    from pos_joined as poj
    left outer join po_amount_unioned as pau on poj.purchase_order_number = pau.purchase_order_number
        and poj.purchase_order_line = pau.purchase_order_line

),

group_purchase_orders as (

    select

        order_number,
        line_number,
        sequence_number,
        purchase_order_number,
        purchase_order_line,
        warehouse_number,
        whs_type,
        purchase_order_currency,
        price,
        discount,
        sum(quantity) as quantity,
        sum(purchase_order_amount) as purchase_order_amount

    from po_amount_joined

    group by all

)

select * from group_purchase_orders
