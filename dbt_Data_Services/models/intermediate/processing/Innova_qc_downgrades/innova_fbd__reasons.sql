with tempparameter as (
    select * from {{ ref('stg_innova_fbdag__qcs_programtemplateparameter') }}
),

rawreasons as (
    select * from {{ ref('stg_innova_fbdag__qcs_dataaggreasons') }}
),

reasons as (
    select
        qcs_dataaggreasons.dataagg as qcs_dataaggreasons_dataagg,
        qcs_dataaggreasons.programparameter as qcs_dataaggreasons_programparameter,
        intlookuptable27931.id as intlookupcol102522,
        qcs_dataaggreasons.rework as qcs_dataaggreasons_rework,
        qcs_dataaggreasons.reject as qcs_dataaggreasons_reject,
        qcs_dataaggreasons.category1 as qcs_dataaggreasons_category1,
        qcs_dataaggreasons.category2 as qcs_dataaggreasons_category2,
        qcs_dataaggreasons.triggerlimits as qcs_dataaggreasons_triggerlimits,
        qcs_programtemplateparameter.basename as qcs_programtemplateparameter_basename,
        qcs_programtemplateparameter.name as qcs_programtemplateparameter_name,
        qcs_programtemplateparameter.sequence as qcs_programtemplateparameter_sequence
    from
       rawreasons as qcs_dataaggreasons
    left join tempparameter as qcs_programtemplateparameter on qcs_dataaggreasons.programparameter = qcs_programtemplateparameter.id
    left join tempparameter as intlookuptable27931 on qcs_dataaggreasons.programparameter = intlookuptable27931.id
)

select * from reasons
