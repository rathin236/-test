with

source as (

    select * from {{ source('api_report', 'incidents') }}

),

renamed as (

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

    from source

)

select * from renamed
