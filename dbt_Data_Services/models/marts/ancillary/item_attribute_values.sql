with item_attribute_begin as (
    select * from {{ ref('int_northscope__item_attribute_values_pre_pivot') }}
),

final as (
    select

        item_sk,
        item_id,
        item_description,
        item_display_description,
        item_type,
        item_class,
        uom_schedule_id,
        uom_schedule_description,
        default_unit_uom,
        default_weight_uom,
        default_price_uom,
        dataentitycompany_sk,
        source_system,
        {{ dbt_utils.pivot(
            'attribute_description',
            dbt_utils.get_column_values( ref('int_northscope__item_attribute_values_pre_pivot'), 'attribute_description'),
            agg = 'max',
            then_value = 'attribute_value',
            else_value = 'null'
            ) }}

    from item_attribute_begin

        {{ dbt_utils.group_by(n = 13) }}
)

select * from final

/* For Testing */
-- where item_sk = 5250

order by item_sk
