with unioned as (

    select * from {{ ref('stg_inspec_fbd__qcfbdemployeegmp') }}

),

filtered as (

    select * from unioned
    where
        status_workflow = 'Finished'

),

transformed as (

    select

        _id as form_id,
        offendername as employee_name,
        context_plant as facility,
        officialtime as created_at,
        descriptionofdeficiency as reason,
        typeofdeficiency as deficinecy,
        comments

    from filtered
),

organized as (

    select

        --pk 
        form_id,

        --fk

        --details
        employee_name,
        reason,
        deficinecy,
        facility,
        comments,

        ----strings

        ----numerics

        ----booleans

        ----dates

        ----timestamps
        created_at

        --metadata

    from transformed

)

select * from organized
