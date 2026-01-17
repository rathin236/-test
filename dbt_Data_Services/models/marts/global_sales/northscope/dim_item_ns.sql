with dim_item_northscope_pre_pivot as (
    select * from {{ ref('int_northscope__item_attribute_values_pre_pivot') }}
),

dim_item_northscope as (
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
        companyname,
        product_lifecycle_status,
        {{ dbt_utils.pivot(
            'attribute_description',
            dbt_utils.get_column_values( ref('int_northscope__item_attribute_values_pre_pivot'), 'attribute_description'),
            agg = 'max',
            then_value = 'attribute_value',
            else_value = 'null'
        ) }}
    from dim_item_northscope_pre_pivot
    {{ dbt_utils.group_by(n = 15) }}
),

crm_item_id as (
    select
        cai_crmproductid as crm_item_id,
        productid as crm_item_sk,
        right(cai_sourcesystemitemid, length(cai_sourcesystemitemid) - 4) as northscope_item_sk
    from {{ ref('stg_crm_dev3__product') }}
    where right(cai_sourcesystemitemid, length(cai_sourcesystemitemid) - 4) is not null
),

final as (
    select
        ns_items.item_sk as "Item_SK",
        ns_items.item_id as "Item ID",
        ns_items.item_description as "Product Name",
        ns_items.source_system as "Company",
        ns_items.companyname as "Company Name",
        ns_items.item_class as "Item Group",
        ns_items.item_class as "Item Group ID",
        ns_items."Country of Origin",
        ns_items."Skin On/Off" as "Skin On Off",
        ns_items."Sub Category",
        ns_items."Bone In Out",
        ns_items."Coolant",
        null as "Harvest",
        ns_items."Package Weight",
        ns_items."Scaled",
        ns_items."Trim",
        ns_items."UB Code",
        ns_items."Whole or VA",
        ns_items."Family",
        ns_items."Form",
        ns_items."Package Unit Count",
        null as "Pieces Per lb Count",
        ns_items."Product Size UOM",
        null as "Production Phase",
        ns_items."Skinning Type",
        null as "ASC Certification",
        ns_items."Frozen Format",
        ns_items."Category",
        ns_items."High Level Grade",
        ns_items."Grade",
        ns_items."Brand",
        ns_items."Size" as "Product Size",
        ns_items."Case Weight",
        ns_items."Case Weight UOM",
        ns_items."Cooked/Raw",
        null as "NFT Label",
        ns_items."Package Weight UOM",
        null as "MSC Certification",
        ns_items."Certification",
        null as rwoa,
        ns_items."Catch Area",
        ns_items."Master Packaging Type",
        ns_items."Private Label" as "Product Label",
        null as "Product Form - Shrimp",
        ns_items."Flavour",
        null as "Harvest Method",
        ns_items."Process Type",
        null as "MSC Number",
        crm_item_id.crm_item_id,
        crm_item_id.crm_item_sk,
        ns_items.product_lifecycle_status,
        coalesce('en-US', nullif(ns_items.item_id, null)) as "Language ID",
        ns_items.item_id || ' - ' || ns_items.item_description as "Item Description",
        coalesce(ns_items."Specie", ns_items."Species") as "Species",
        coalesce(ns_items."Sub-Species", ns_items."Sub Species", ns_items."Sub Specie") as "Sub-Species",
        coalesce(ns_items."Inside Pack Type", ns_items."Inside Pack") as "Inside Pack",
        coalesce(ns_items."Whole/VA", ns_items."Whole or VA") as "Value Add"
    from dim_item_northscope as ns_items
    left join crm_item_id
        on ns_items.item_sk = crm_item_id.northscope_item_sk
    qualify row_number() over (partition by ns_items.item_sk order by ns_items.item_sk) = 1
)

select * from final

/* For Testing */
-- where "Item ID" = '21347'
