with customer_item_id_targets_item_id as (
    select distinct
        it.quarter,
        it.item_id,
        it.customer_id,
        it.source_system,
        it.customer_name,
        it.customer_target_by_item_id
    from {{ ref('stg_sales__customer_item_id_targets_item_id') }} as it
),

item as (
    select
        i."Item ID",
        i."Item_SK",
        i."Category",
        i."Item Description" as item_description,
        i.sourcesystem,
        count(*) over (partition by i."Item ID", i.sourcesystem order by i."Item_SK") as dedupe
    from {{ ref('dim_item') }} as i
),

 cte as (
    select distinct
        it.quarter,
        i."Category",
        it.item_id,
        it.customer_id,
        it.source_system,
        it.customer_name,
        i.item_description,
        it.customer_target_by_item_id
    from customer_item_id_targets_item_id as it

    left join item as i
        on it.item_id = i."Item ID"
            and it.source_system = i.sourcesystem

    where i.dedupe = 1
),

final as (
    select distinct
        cte.quarter,
        cte.item_id,
        cte.customer_id,
        cte.source_system,
        cte.customer_name,
        cte.item_description,
        ic.combined_item_category,
        cte.customer_target_by_item_id,
        ic.customer_target_by_item_category

    from {{ ref('stg_sales__customer_item_category_targets_item_category') }} as ic

    left join cte
        on lower(ic.item_category) = lower(cte."Category")
            and ic.source_system = cte.source_system
            and ic.customer_id = cte.customer_id

    where cte.item_id is not null
        or cte.customer_id is not null

)

select * from final
