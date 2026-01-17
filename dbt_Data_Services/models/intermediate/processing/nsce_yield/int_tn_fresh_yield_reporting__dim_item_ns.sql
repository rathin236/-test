with vwx_im_item_attribute_values as (
    select * from {{ ref('item_attribute_values') }}
),

erpx_im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),

int_tnfresh_yield_reporting__dim_item_ns as (
    select

        iav.item_id as "ItemNumber",
        iav.item_description as "ItemDescription",
        iav.item_display_description as "ItemDisplayDescription",
        iav.item_type as "ItemType",
        iav.item_class as "ItemClass",
        iav."Catch Area" as "CatchArea",
        iav."Category",
        iav."CW Category" as "CWCategory",
        iav."Division",
        iav."Family",
        iav."Finished Form" as "FinishedForm",
        iav."Form",
        iav."Grade",
        iav."High Level Category" as "HighLevelCategory",
        iav."High Level Grade" as "HighLevelGrade",
        iav."Inside Pack Type" as "InsidePackType",
        iav."Master Packaging Type" as "MasterPackagingType",
        iav."Scaled",
        iav."Size",
        iav."Skin On/Off" as "SkinOnOff",
        iav."Skinning Type" as "SkinningType",
        iav."Specie" as "Species",
        iav."Sub Category" as "SubCategory",
        iav."Sub Specie" as "SubSpecies",
        iav."Trim",
        iav."Whole or VA" as "WholeVa",
        iav."Wild or Farm" as "WildOrFarmed",
        iav."Yield Class" as "YieldClass",
        'NS_' || trim(to_char(iav.item_sk)) as "Key_Item"

    from vwx_im_item_attribute_values as iav

    inner join erpx_im_item as item
        on iav.item_sk = item.itemsk

    where iav.dataentitycompany_sk = 1
        and iav."Division" = 'TNS'

)

select * from int_tnfresh_yield_reporting__dim_item_ns
