with routing_group as (

    select * from {{ ref('int_edi_856__gfs_routing_group_case_level') }}

    union all

    select * from {{ ref('int_edi_856__gfs_routing_group_raw_material') }}

)

select

    sum(shipment_net_weight_kg) as shipment_net_weight_kg,
    sum(shipment_net_weight_lb) as shipment_net_weight_lb,
    sum(shipment_gross_weight_kg) as shipment_gross_weight_kg,
    sum(shipment_gross_weight_lb) as shipment_gross_weight_lb,
    sum(shipment_volume) as shipment_volume,
    volume_uom,
    routing_seq_code,
    id_code_qual,
    id_code,
    routing,
    fob,
    order_id,
    sum(number_of_pallets) as number_of_pallets,
    sum(number_of_cases) as number_of_cases,
    packaging_code,
    trans_type_code
from routing_group

/* For Testing */
-- where order_id like '%TNS308550%'

group by all
