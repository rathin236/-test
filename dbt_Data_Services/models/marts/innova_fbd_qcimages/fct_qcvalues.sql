with qcinfo as (
    select * from {{ ref('innova_fbd__qcinfo') }}
),
qcvalues as (
    select * from {{ ref('innova_fbd__qcvalues') }}
),
final as (
select qcvalues.* from qcvalues

join qcinfo
on qcinfo.qcs_dataagg_id = qcvalues.qcs_dataaggvalues_dataagg
)
select * from final
