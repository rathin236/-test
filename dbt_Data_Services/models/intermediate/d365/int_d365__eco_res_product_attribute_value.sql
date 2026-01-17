-- with eco_res_attribute_value as (
--     select * from {{ ref('stg_d365__eco_res_attribute_value') }}
-- ),

-- eco_res_instance_value as (
--     select * from {{ ref('stg_d365__eco_res_instance_value') }}
-- ),

-- eco_res_product_attribute_value as (
--     select

--         era.value as value_,
--         era.attribute,
--         era.recid as table_rec_id,
--         era.partition,
--         era.recid,
--         eri.product,
--         eri.partition as partition_2

--     from eco_res_attribute_value as era

--     cross join eco_res_instance_value as eri

--     where
--         era.instancevalue = eri.recid
--         and era.partition = eri.partition
--         and eri.instancerelationtype in (4595)
-- )

select
    value as value_,
    attribute,
    recid as table_rec_id,
    partition,
    product
from {{ ref('stg_d365__product_attribute_value') }}
