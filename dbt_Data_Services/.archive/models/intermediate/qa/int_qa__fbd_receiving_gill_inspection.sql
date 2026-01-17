with receiving_gill_inspection as (

    select * from {{ ref('stg_inspec_fbd__qcbhreceivinggillinspection') }}

),

filtered as (

    select * from receiving_gill_inspection
    where status_workflow = 'Finished'

)

select * from filtered
