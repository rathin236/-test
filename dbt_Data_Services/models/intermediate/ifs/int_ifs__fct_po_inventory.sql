with po_data as (
    select
        order_no,
        line_no,
        release_no,
        part_no,
        company,
        purchase_site,
        invoicing_supplier,
        delivery_terms,
        ship_via_code,
        note_id,
        inventory_part,
        rowstate as po_status,
        date_entered,
        wanted_delivery_date,
        planned_delivery_date,
        last_activity_date,
        buy_unit_price as unit_price,
        buy_qty_due as qty,
        buy_unit_meas as uom,
        currency_code,
        to_numeric(to_varchar(to_timestamp(date_entered), 'yyyymmdd')) as key_date_entered,
        case
            when rowtype = 'PurchaseOrderLinePart' then 'Part Order Lines'
            when rowtype = 'PurchaseOrderLineNopart' then 'No Part Order Lines'
            else 'N/A'
        end as po_type,
        date(planned_receipt_date) as planned_receipt_date,
        round(buy_unit_price * buy_qty_due, 2) as total_price

    from {{ ref('stg_ifs__purchase_order_line_tab') }}
)

select * from po_data
