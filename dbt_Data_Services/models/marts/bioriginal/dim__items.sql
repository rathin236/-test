with itm as (

    select * from {{ ref("int_items__unioned") }}

),

itm_prod_class as (

    select * from {{ ref("int_product_classes__unioned") }}

),

itm_sales as (

    select * from {{ ref("int_item_sales__unioned") }}

),

itm_stat_grp as (

    select * from {{ ref("int_statistical_group__unioned") }}

),

itm_cost as (

    select * from {{ ref("int_item_costing__unioned") }}

),

product_grouping_summary as (

    select * from {{ ref("bioriginal__product_grouping_summary") }}
),

join_prod_class as (

    select

        item_number,
        item_description,
        product_category_grouping_description,
        itm.company_code

    from itm
    left outer join itm_prod_class on itm.item_product_class = itm_prod_class.item_product_class
        and itm.company_code = itm_prod_class.company_code

),

join_item_sales as (

    select

        join_prod_class.item_number,
        item_description,
        product_category_grouping_description,
        item_product_category_description,
        join_prod_class.company_code

    from join_prod_class

    left join itm_sales on join_prod_class.item_number = itm_sales.item_number
        and join_prod_class.company_code = itm_sales.company_code

),

join_item_stat_group as (

    select

        item_number,
        item_description,
        product_category_grouping_description,
        product_category_description,
        join_item_sales.company_code

    from join_item_sales

    left join itm_stat_grp on join_item_sales.item_product_category_description = itm_stat_grp.id
        and join_item_sales.company_code = itm_stat_grp.company_code

),

join_item_cost as (

    select

        join_item_stat_group.item_number,
        item_description,
        product_category_grouping_description,
        product_category_description,
        join_item_stat_group.company_code,
        round(standard_cost, 2) as standard_cost

    from join_item_stat_group

    left join itm_cost on join_item_stat_group.item_number = itm_cost.item_number
        and join_item_stat_group.company_code = itm_cost.company_code

),

add_key as (

    select

        item_number,
        item_description,
        product_category_grouping_description,
        product_category_description,
        company_code,
        standard_cost,
        item_number::string || '_' || company_code::string as item_key

    from join_item_cost

),

add_prod_group_summary as (

    select

        item_number,
        item_description,
        add_key.product_category_grouping_description,
        coalesce(product_category_grouping_summary, 'OTHER') as product_category_grouping_summary,
        product_category_description,
        company_code,
        standard_cost,
        item_key

    from add_key

    left join product_grouping_summary
        on add_key.product_category_grouping_description = product_grouping_summary.product_category_grouping_description

)

select * from add_prod_group_summary
