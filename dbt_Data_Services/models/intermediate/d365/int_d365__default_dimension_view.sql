with dimension_attribute_value_set_item as (
    select * from {{ ref('stg_d365__dimension_attribute_value_set_item') }}
),

dimension_attribute_value as (
    select * from {{ ref('stg_d365__dimension_attribute_value') }}
),

dimension_attribute as (
    select * from {{ ref('stg_d365__dimension_attribute') }}
),

final as (
    select

        davst.displayvalue,
        davst.dimensionattributevalueset as default_dimension,
        davst.recid as table_rec_id,
        dav.entityinstance,
        dav.partition as partition_2,
        dat.reportcolumnname,
        dat.recid as dimension_attribute_id,
        dat.backingentitytype,
        dat.keyattribute,
        dat.nameattribute,
        dat.name,
        dat.partition as partition_3

    from dimension_attribute_value_set_item as davst
    cross join dimension_attribute_value as dav
    cross join dimension_attribute as dat

    where davst.dimensionattributevalue = dav.recid
        and davst.partition = dav.partition
        and dav.dimensionattribute = dat.recid
        and dav.partition = dat.partition
)

select * from final
