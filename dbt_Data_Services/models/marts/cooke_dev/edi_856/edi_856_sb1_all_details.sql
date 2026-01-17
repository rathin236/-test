with all_details as (
    select

        seg.order_id,
        seg.client_id,
        seg.source,
        seg.date_created,
        heg.entity_id_code as header_entity_id_code,
        heg.transaction_purpose,
        heg.bol_number,
        heg.ship_date,
        heg.ship_time,
        heg.actualshipdate as ship_datetime,
        heg.delivery_date,
        heg.edi_division,
        count(distinct pag.pallet_id) over (partition by seg.order_id) as number_of_pallets,
        rog.packaging_code,
        rog.shipment_volume,
        rog.volume_uom,
        rog.routing_seq_code,
        rog.trans_type_code,
        rog.routing,
        rog.fob,
        eqg.equipment_desc_code,
        adg.entity_id_code as address_entity_id_code,
        adg.edi_bill_to_id_code,
        adg.accounting_id_code,
        adg.name_ as ship_name,
        adg.address_1 as ship_address_1,
        adg.address_2 as ship_address_2,
        adg.city as ship_city,
        adg.state as ship_state,
        adg.zip as ship_zip,
        adg.country as ship_country,
        adg.contact_phone,
        adg.phone_fax,
        org.po_number,
        org.po_date,
        org.order_id as sales_order_number,
        org.ref_num_qual,
        org.scac as id_code,
        2 as id_code_qual,
        pag.id_type,
        pag.sscc_checksum as id,
        pag.pallet_type,
        pag.pallet_layers,
        pag.pallet_blocks,
        pag.pallet_pack,
        itg.case_code,
        itg.upc_code,
        itg.qty_shipped,
        itg.qty_ordered,
        itg.uom as qty_uom,
        itg.unit_price,
        itg.unit_price_uom,
        itg.is_catch_wgt,
        itg.net_unit_price,
        itg.extended_net_price,
        itg.item_number,
        itg.item_description,
        itg.cooke_item_id as erp_item_code,
        itg.po_line_id,
        itg.number_of_cases,
        itg.serial_lot_number,
        itg.production_date,
        itg.expiry_date,
        round(rog.shipment_net_weight_kg, 2) as shipment_net_weight_kg,
        round(rog.shipment_net_weight_lb, 2) as shipment_net_weight_lb,
        round(rog.shipment_gross_weight_kg + ((count(distinct pag.sscc_checksum) over (partition by seg.order_id) * ('{{ var("edi_856_pallet_weight_lb") }}' / 2.20462))), 2) as shipment_gross_weight_kg,
        round(rog.shipment_gross_weight_lb + (count(distinct pag.sscc_checksum) over (partition by seg.order_id) * '{{ var("edi_856_pallet_weight_lb") }}'), 2) as shipment_gross_weight_lb,
        round(pag.pallet_net_weight_kg, 2) as item_pallet_net_weight_kg,
        round(pag.pallet_net_weight_lb, 2) as item_pallet_net_weight_lb,
        round(itg.gross_weight_kg, 2) as lot_item_net_weight_kg,
        round(itg.gross_weight_lb, 2) as lot_item_net_weight_lb,
        '{{ var("edi_856_pallet_weight_lb") }}' as physical_pallet_weight_lb,
        round('{{ var("edi_856_pallet_weight_lb") }}' / 2.20462, 4) as physical_pallet_weight_kg

    from {{ ref('edi_856_sb1_sender_group') }} as seg

    inner join {{ ref('edi_856_sb1_header_group') }} as heg
        on seg.order_id = heg.order_id

    inner join {{ ref('edi_856_sb1_routing_group') }} as rog
        on seg.order_id = rog.order_id

    inner join {{ ref('edi_856_sb1_equipment_group') }} as eqg
        on seg.order_id = eqg.order_id

    inner join {{ ref('edi_856_sb1_address_group') }} as adg
        on seg.order_id = adg.order_id

    inner join {{ ref('edi_856_sb1_order_group') }} as org
        on seg.order_id = org.order_id

    inner join {{ ref('edi_856_sb1_pallet_group_sscc') }} as pag
        on seg.order_id = pag.order_id

    inner join {{ ref('edi_856_sb1_item_group') }} as itg
        on seg.order_id = itg.order_id
            and pag.pallet_id = itg.pallet_id
            and pag.cooke_item_id = itg.cooke_item_id

)

select * from all_details

/* For Testing */
-- where order_id like '%26010%'
