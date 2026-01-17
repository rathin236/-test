with process_reporting as (
    select * from {{ ref('int_boomi__process_reporting') }}
),

final as (
    select

        atomname,
        processid,
        processname,
        status,
        executiontype,
        executiontime,
        executionid,
        executionduration,
        inbounddocumentcount,
        inbounddocumentsize,
        outbounddocumentcount,
        outbounddocumentsize,
        insert_date,
        start_date,
        end_date

    from process_reporting
)

select * from final
