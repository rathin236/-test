with

source as (

    select * from {{ source('sales_targets_customer_items', 'customer_item_category_targets_item_category') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        customer_id,
        source_system,
        customer_target_by_item_category,
        combined_item_category,
        customer_name,
        quarter,
        item_category

    from source
)

select * from renamed
