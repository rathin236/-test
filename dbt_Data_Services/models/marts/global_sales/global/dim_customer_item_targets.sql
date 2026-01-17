with customer_item_targets as (
    select
        quarter,
        item_id,
        customer_id,
        md5(concat(item_id, source_system)) as sk_item_targets,
        md5(concat(customer_id, source_system)) as sk_customer_id_targets,
        source_system,
        customer_name,
        item_description,
        combined_item_category,
        customer_target_by_item_id,
        customer_target_by_item_category
    from {{ ref('int_sales__customer_targets') }}
)

select * from customer_item_targets
where customer_target_by_item_category is not null 
    or customer_target_by_item_id is not null
