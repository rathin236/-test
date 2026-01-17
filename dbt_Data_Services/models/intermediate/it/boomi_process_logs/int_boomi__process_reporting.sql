with process_reporting as (
    select

        v.value:atomName::string as atomname,
        v.value:processId::string as processid,
        v.value:processName::string as processname,
        v.value:status::string as status,
        v.value:executionType::string as executiontype,
        v.value:executionTime::timestamp_ntz as executiontime,
        v.value:executionId::string as executionid,
        v.value:executionDuration[1]::number as executionduration,
        v.value:inboundDocumentCount::number as inbounddocumentcount,
        v.value:inboundDocumentSize[1]::number as inbounddocumentsize,
        v.value:inboundErrorDocumentCount::number as inbounderrordocumentcount,
        v.value:outboundDocumentCount::number as outbounddocumentcount,
        v.value:outboundDocumentSize[1]::number as outbounddocumentsize,
        v.value:insert_date as insert_date,
        v.value:start_date as start_date,
        v.value:end_date as end_date

    from {{ ref('stg_boomi__process_reporting') }} as prr,
        lateral flatten(input => prr.json_data:result) as v
    qualify
        row_number()
            over (
                partition by v.value:executionId order by v.value:executionTime
            )
        = 1

)

select * from process_reporting
