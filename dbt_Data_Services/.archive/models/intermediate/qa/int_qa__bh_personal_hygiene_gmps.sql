with unioned as (

    select * from {{ ref('stg_inspec_fbd__qcbhpersonalhygienegmps') }}

),

filtered as (

    select * from unioned
    where
        status_workflow = 'Finished'

),

transformed as (

    select

        _id as form_id,
        employeename as employee_name,
        shiftmonitored as shift,
        reasonforother as reason,
        deficiencies as deficinecy,
        context_plant as facility,
        officialtime as created_at

    from filtered
),

organized as (

    select

        --pk
        form_id,

        --fk

        --details
        ----strings
        employee_name,
        reason,
        deficinecy,
        facility,

        ----numerics

        ----booleans

        ----dates

        ----timestamps
        created_at

        --metadata

    from transformed

)

select * from organized
