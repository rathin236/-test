with view_supply_curves_final as (
    select * from {{ ref('int_kontali_view2_supply') }}
)

select * from view_supply_curves_final
