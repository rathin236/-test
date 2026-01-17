with main as (
    select
        resource_id,
        start_date,
        end_date,
        modified_date,
        parse_json(json_data) as json_data
    from
        {{ ref('stg_ppm__resourcecapacity') }}
),

fields as (
    select
        resource_id,
        start_date,
        end_date,
        modified_date,
        entry.value:"entryDate"::date as entry_date,
        entry.value:"entryHours"::number as entry_hours,
        row_number() over (
            partition by resource_id, entry.value:"entryDate"::date
            order by modified_date desc
        ) as row_num
    from
        main,
        lateral flatten(input => main.json_data:"soapenv:Envelope"."soapenv:Body"."ns:getContourResponse"."ns:return"."entries") as entry
    qualify
        row_num = 1 and entry_date >= '2023-01-01'

)

select * from fields
