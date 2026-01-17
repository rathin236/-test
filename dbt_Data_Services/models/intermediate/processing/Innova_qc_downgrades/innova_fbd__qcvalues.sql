with tempparameter as (
    select * from {{ ref('stg_innova_fbdag__qcs_datatemplateparameter') }}
),

rawvalues as (
    select * from {{ ref('stg_innova_fbdag__qcs_dataaggvalues') }}
),

qcvalues as (
    select
        qcs_dataaggvalues.dataagg as qcs_dataaggvalues_dataagg,
        qcs_dataaggvalues.dataparameter as qcs_dataaggvalues_dataparameter,
        intlookuptable27935.id as intlookupcol102524,
        qcs_datatemplateparameter.basename as qcs_datatemplateparameter_basename,
        qcs_datatemplateparameter.name as qcs_datatemplateparameter_name,
        qcs_datatemplateparameter.unit as qcs_datatemplateparameter_unit,
        qcs_datatemplateparameter.scaling as qcs_datatemplateparameter_scaling,
        qcs_datatemplateparameter.active as qcs_datatemplateparameter_active,
        qcs_dataaggvalues.value / coalesce(nullif(qcs_datatemplateparameter.scaling, 0), 1) as qcs_dataaggvalues_value,
        qcs_dataaggvalues.valuep2 / coalesce(nullif(qcs_datatemplateparameter.scaling, 0), 1) as qcs_dataaggvalues_valuep2,
        qcs_dataaggvalues.min / coalesce(nullif(qcs_datatemplateparameter.scaling, 0), 1) as qcs_dataaggvalues_min,
        qcs_dataaggvalues.max / coalesce(nullif(qcs_datatemplateparameter.scaling, 0), 1) as qcs_dataaggvalues_max,
        case qcs_datatemplateparameter.unit
            when 801 then '°C'
            when 1901 then '%'
            when 401 then 'mm'
            when 4 then 'colorgrade'
            when 1002 then 'mm²'
            when 1105 then 'mm³'
            when 202 then 'gm'
            else cast(qcs_datatemplateparameter.unit as string)
        end as unit_of_measure
    from
        rawvalues as qcs_dataaggvalues
    left outer join tempparameter as qcs_datatemplateparameter on qcs_dataaggvalues.dataparameter = qcs_datatemplateparameter.id
    left outer join tempparameter as intlookuptable27935 on qcs_dataaggvalues.dataparameter = intlookuptable27935.id
)

select * from qcvalues
