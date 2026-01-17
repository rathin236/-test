with qcinfo as (
    select * from {{ ref('innova_fbd__qcinfo') }}
),
typecount as (
    select * from {{ ref('innova_fbd__typecount') }}
),
final as (
select typecount.* from typecount

join qcinfo
on qcinfo.qcs_dataagg_id = typecount.qcs_dataaggtypecount_dataagg
)
select * from final
