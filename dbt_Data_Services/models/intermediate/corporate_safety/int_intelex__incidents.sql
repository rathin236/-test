with base as (
    select
        id,
        updated,
        row_num,
        record_no,
        location,
        location_id,
        event_type,
        severity,
        case_classification,
        date,
        status,
        execution_id,
        system_type
    from {{ ref('stg_intelex__incidents') }}
),

ranked as (
    select *
    from base
    qualify row_number() over (partition by record_no order by updated desc) = 1
)

select * from ranked
