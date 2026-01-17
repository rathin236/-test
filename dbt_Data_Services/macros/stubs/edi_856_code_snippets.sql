{{ codegen.generate_model_yaml(
    upstream_descriptions = True,
    model_names = [
                    'edi_856_all_details',
                    'edi_856_address_group',
                    'edi_856_advance_ship_notice',
                    'edi_856_equipment_group',
                    'edi_856_header_group',
                    'edi_856_item_group',
                    'edi_856_order_group',
                    'edi_856_pallet_group_sscc',
                    'edi_856_routing_group',
                    'edi_856_sender_group',
                    ]
) }}