with qcinfo as (
    select * from {{ ref('innova_fbd__qcinfo') }}
),
reasons as (
    select * from {{ ref('innova_fbd__reasons') }}
),
final as (
select reasons.* from reasons

join qcinfo
on qcinfo.qcs_dataagg_id = reasons.qcs_dataaggreasons_dataagg
)
select * from final
