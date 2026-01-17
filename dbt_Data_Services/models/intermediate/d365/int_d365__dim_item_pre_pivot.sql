with d365_dim_item_pre_pivot as (
    select

        erpa.product,
        erp.displayproductnumber,
        iig.name as item_group,
        iig.itemgroupid as item_group_id,
        era.name as attribute,
        erv.textvalue,
        erpt.description as product_name,
        erpt.languageid,
        igi.itemgroupdataareaid,
        iig.dataareaid

    from {{ ref('stg_d365__invent_table') }} as itb

    left join {{ ref('stg_d365__eco_res_product') }} as erp
        on itb.product = erp.recid

    left join {{ ref('int_d365__eco_res_product_attribute_value') }} as erpa
        on erp.recid = erpa.product

    left join {{ ref('stg_d365__eco_res_attribute') }} as era
        on erpa.attribute = era.recid

    left join {{ ref('stg_d365__eco_res_value') }} as erv
        on erpa.value_ = erv.recid

    left join {{ ref('stg_d365__eco_res_product_translation') }} as erpt
        on erpa.product = erpt.product

    left join {{ ref('stg_d365__invent_item_group_item') }} as igi
        on itb.itemid = igi.itemid
       and trim(upper(itb.dataareaid)) = trim(upper(igi.itemdataareaid))

    left join {{ ref('stg_d365__invent_item_group') }} as iig
        on igi.itemgroupid = iig.itemgroupid
            and trim(upper(igi.itemgroupdataareaid)) = trim(upper(iig.dataareaid))
)

select * from d365_dim_item_pre_pivot

/* For Testing */
{# where displayproductnumber in ('P1003848') #}
