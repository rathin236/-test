with released_products as (
    select {{ trim_columns_int('stg_d365__invent_table') }}
    from {{ ref('stg_d365__invent_table') }}
),

dav as (
    select {{ trim_columns_int('stg_d365__dimension_attribute_value') }}
    from {{ ref('stg_d365__dimension_attribute_value') }}
),

dvs as (
    select {{ trim_columns_int('stg_d365__dimension_attribute_value_set') }}
    from {{ ref('stg_d365__dimension_attribute_value_set') }}
),

dvsi as (
    select {{ trim_columns_int('stg_d365__dimension_attribute_value_set_item') }}
    from {{ ref('stg_d365__dimension_attribute_value_set_item') }}
),

dim_attribute as (
    select {{ trim_columns_int('stg_d365__dimension_attribute') }}
    from {{ ref('stg_d365__dimension_attribute') }}
),

fin_tag as (
    select {{ trim_columns_int('stg_d365__dimension_financial_tag') }}
    from {{ ref('stg_d365__dimension_financial_tag') }}
),

product_line as (
    select
        rlp.itemid,
        dim_a.name as dimension_name,
        dav.displayvalue as productline_value,
        fin_tag.description as productline_name,
        productline_value || ' - ' || productline_name as productline_desc,
        case when rlp.productlifecyclestateid = 'ISACTIVEFORPLANNING' then 'ACTIVE'
            else 'INACTIVE'
        end as productlifecyclestateid
    from released_products as rlp

    left join dvs
        on rlp.defaultdimension = dvs.recid

    left join dvsi
        on dvs.recid = dvsi.dimensionattributevalueset

    left join dav
        on dvsi.dimensionattributevalue = dav.recid

    left join dim_attribute as dim_a
        on dav.dimensionattribute = dim_a.recid

    left join fin_tag
        on dav.entityinstance = fin_tag.recid

    where dim_a.name ilike '%PRODUCTLINE%'

)

select * from product_line
