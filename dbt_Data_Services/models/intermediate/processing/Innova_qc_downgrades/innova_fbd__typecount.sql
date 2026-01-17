with typecount as (
    select
        dataagg as qcs_dataaggtypecount_dataagg,
        type as qcs_dataaggtypecount_type,
        triggerlimitpieces as qcs_dataaggtypecount_triggerlimitpieces,
        triggerlimittotal as qcs_dataaggtypecount_triggerlimittotal,
        case type
            when 0 then 'Trimming Defect'
            when 3 then 'Generic'
            else 'No Values Found'
        end as type_name
    from {{ ref('stg_innova_fbdag__qcs_dataaggtypecount') }}
)

select * from typecount
