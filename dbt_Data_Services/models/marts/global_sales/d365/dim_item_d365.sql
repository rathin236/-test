with
itm_pre_pivot as (
    select
        items.*,
        prod_line.productline_value,
        prod_line.productline_name,
        prod_line.productline_desc,
        prod_line.productlifecyclestateid as product_lifecycle_state
    from {{ ref('int_d365__dim_item_pre_pivot') }} as items
    left join {{ ref('int_d365__item_product_line') }} as prod_line
        on items.displayproductnumber = prod_line.itemid
),

itm_d365 as (
    select
        items.displayproductnumber,
        items.product_name,
        items.dataareaid,
        items.languageid,
        items.item_group,
        items.item_group_id,
        items.displayproductnumber || '-' || items.product_name as item_description,
        items.productline_value,
        items.productline_desc,
        items.productline_name,
        items.product_lifecycle_state as product_lifecycle_status,
            {{ dbt_utils.pivot(
                'attribute',
                dbt_utils.get_column_values( ref('int_d365__dim_item_pre_pivot'), 'attribute'),
                agg = 'max',
                then_value = 'textvalue',
                else_value = 'null'
            ) }}
    from itm_pre_pivot as items
    {{ dbt_utils.group_by(n = 11) }}
),

crm_itm_id as (
    select
        prod.cai_d_365_productid as d365_product_id,
        prod.cai_crmproductid as crm_item_id,
        prod.productid as crm_item_sk
    from {{ ref('stg_crm_dev3__product') }} as prod
    where prod.cai_d_365_productid is not null
),

company as (
    select {{ trim_columns_int('stg_d365__data_area') }}
    from {{ ref('stg_d365__data_area') }}
    where fno_id = 'TNSF'
),

itm as (
    select
        null as "Item_SK",
        d365.displayproductnumber as "Item ID",
        d365.product_name as "Product Name",
        company.name as "Company Name",
        d365.languageid as "Language ID",
        d365.item_group as "Item Group",
        d365.item_group_id as "Item Group ID",
        d365.item_description as "Item Description",
        d365."Country of Origin",
        d365."Skin On Off",
        d365."Sub Category",
        d365."Bone In Out",
        d365."Coolant",
        d365."Harvest",
        d365."Package Weight",
        d365."Scaled",
        d365."Trim",
        d365."UB Code",
        d365."Whole or VA",
        d365."Family",
        d365."Form",
        d365."Package Unit Count",
        d365."Pieces Per lb Count",
        d365."Product Size UOM",
        d365."Production Phase",
        d365."Skinning Type",
        d365."ASC Certification",
        d365."Species",
        d365."Sub-Species",
        d365."Frozen Format",
        d365."Category",
        d365."High Leve Grade" as "High Level Grade",
        d365."Grade",
        d365."Brand",
        d365."Product Size",
        d365."Case Weight",
        d365."Case Weight UOM",
        d365."Cooked/Raw",
        d365."NFT Label",
        d365."Package Weight UOM",
        d365."MSC Certification",
        null as "Certification",
        d365.rwoa,
        d365."Catch Area",
        d365."Inside Pack",
        d365."Master Packaging Type",
        d365."Product Label",
        d365."Value Add",
        d365."Product Form - Shrimp",
        d365."Flavour",
        d365."Harvest Method",
        null as "Process Type",
        d365."MSC Number",
        crm_itm_id.crm_item_id,
        crm_itm_id.crm_item_sk,
        d365.productline_value,
        d365.productline_name,
        d365.productline_desc,
        d365.product_lifecycle_status,
        upper(trim(d365.dataareaid)) as "Company"
    from itm_d365 as d365
    left join crm_itm_id
        on d365.displayproductnumber = crm_itm_id.d365_product_id
    left join company
        on upper(trim(d365.dataareaid)) = company.fno_id
    qualify row_number() over (partition by d365.displayproductnumber order by d365.displayproductnumber) = 1
    {# order by d365.displayproductnumber #}
)

select * from itm

/* For Testing */
-- where item_id = 'P1001602'
