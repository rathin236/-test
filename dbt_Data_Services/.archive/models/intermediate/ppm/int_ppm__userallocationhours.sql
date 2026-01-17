with main as (
    select
        allocation_id,
        start_date,
        modified_date,
        end_date,
        parse_json(json_data) as json_data
    from
        {{ ref('stg_ppm__userallocationhours') }}
    -- latest entry getting from staging table 
),

fields as (
    select
        start_date,
        end_date,
        allocation_id,
        modified_date,
        main.json_data:"soapenv:Envelope"."soapenv:Body"."ns:getContourResponse"."ns:return"."entityTypeId"::string as entitytypeid,
        entries.value:"entryDate"::string as entrydate,
        entries.value:"entryHours"::string as entryhours,
        entries.value:"xsi:type"::string as type
    from
        main,
        lateral flatten(input => main.json_data:"soapenv:Envelope"."soapenv:Body"."ns:getContourResponse"."ns:return"."entries") as entries
)

select * from fields
