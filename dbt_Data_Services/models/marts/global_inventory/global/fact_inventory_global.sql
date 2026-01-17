with fact_inventory as (
-- noqa: disable=PRS
    {{ dbt_utils.union_relations(

    relations=[ref('fact_inventory_d365_current'),
                ref('fact_inventory_coolearth_current')
    ]
) }}
-- noqa: disable=PRS
),

sk_global as (
    select
        "Company",
        sourcesystem,
        sourcesystemcode,
        warehouse_sk,
        "Item ID",
        "Batch Number",
        "Pallet Number",
        "Location ID (Bin)",
        "Label Date",
        "Expiry Date",
        "Cases",
        "Quantity",
        "Available Quantity",
        "Available Cases",
        "Available LBs",
        "Picked Quantity",
        "Picked Cases",
        "Picked LBs",
        "Unit of Measure",
        "Qty LBs",
        "Qty KGs",
        age,
        invent_status,
        "Inv Commitment Value",
        coalesce("Form", 'Frozen') as "Form",
        {{ standard_unit ('"Unit of Measure"') }} as "Standard Unit",
        case when age <= 2 then 1 else 0 end as flag_age0to3days,
        case when age >= 3 and age <= 6 then 1 else 0 end as flag_age3to6days,
        case when age >= 7 and age <= 4000 then 1 else 0 end as flag_age7plusdays,
        case when age <= 182 then 1 else 0 end as flag_age0to6m,
        case when age >= 183 and age <= 366 then 1 else 0 end as flag_age7to12m,
        case when age >= 367 and age <= 550 then 1 else 0 end as flag_age13to18m,
        case when age >= 551 and age <= 732 then 1 else 0 end as flag_age19to24m,
        case when age >= 733 and age <= 99999999999999 then 1 else 0 end as flag_age25morolder,
        case when (age >= -5000 and age <= -1) or age >= 4000 then 1 else 0 end as flag_badproddate,
        case
            when "Form" like '%Fresh%' and flag_age0to3days = 1 then '0-2 Days'
            when "Form" like '%Fresh%' and flag_age3to6days = 1 then '3-6 Days'
            when "Form" like '%Fresh%' and flag_age7plusdays = 1 then '7+ Days'
            when "Form" like '%Fresh%' and flag_badproddate = 1 then 'No Production Date'
            when "Form" not like '%Fresh%' then 'Frozen'
        end as "Aging Groups (Fresh)",
        case
            when "Form" not like '%Fresh%' and flag_age0to6m = 1 then '0-6m'
            when "Form" not like '%Fresh%' and flag_age7to12m = 1 then '7-12m'
            when "Form" not like '%Fresh%' and flag_age13to18m = 1 then '13-18m'
            when "Form" not like '%Fresh%' and flag_age19to24m = 1 then '19-24m'
            when "Form" not like '%Fresh%' and flag_age25morolder = 1 then '25m or Older'
            when "Form" not like '%Fresh%' and flag_badproddate = 1 then 'Bad Product Date'
            when year("Label Date") < 2015 then 'No Production Date'
            when "Label Date" is null then 'No Production Date'
            when "Form" like '%Fresh%' then 'Fresh'
        end as "Aging Group (Frozen)",
        md5(concat(trim("Item ID"), sourcesystem)) as sk_item_global,
        md5(concat(warehouse_sk, sourcesystem)) as sk_warehouse_global,
        fact_inventory_pk
    -- md5(concat(site_sk, sourcesystem)) as sk_site_global (for future use)

    from fact_inventory
)

select * from sk_global
-- for testing
-- where "Item ID" = 'P1004314'
