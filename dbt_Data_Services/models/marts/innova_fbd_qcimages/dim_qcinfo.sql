with qcinfo as (
    select * from {{ ref('innova_fbd__qcinfo') }}
)
select * from qcinfo
