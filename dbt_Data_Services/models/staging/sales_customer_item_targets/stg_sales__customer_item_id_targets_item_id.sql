with

source as (

    select * from {{ source('sales_targets_customer_items', 'customer_item_id_targets_item_id') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        item_id,
        customer_id,
        source_system,
        customer_name,
        item_description,
        quarter,
        customer_target_by_item_id

    from source
)

select * from renamed
