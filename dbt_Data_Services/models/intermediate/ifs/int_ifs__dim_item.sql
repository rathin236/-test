with part_catalog as (
    select * from {{ ref('stg_ifs__part_catalog_tab') }}

)

select
    part_no,
    weight_net,
    lot_quantity_rule,
    description as item_description,
    cast(rowversion as date) as version_date,
    unit_code,
    uom_for_weight_net

from part_catalog
