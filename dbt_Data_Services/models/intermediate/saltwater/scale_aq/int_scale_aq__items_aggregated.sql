with source as (
    select parse_json(json_data) as json_data
    from {{ ref('stg_scale_aq__iot_raw_data') }}
),

items as (
    select
        f.value:"siteId"::number as site_id,
        f.value:"unitId"::number as unit_id,
        f.value:"dataType"::string as data_type,
        f.value:"measurement"::string as measurement,
        null as silo_id,
        (f.value:"value"::number)::double as item_value,
        convert_timezone('UTC', 'America/Halifax', f.value:"dateTime"::timestamp_ntz) as date_time,
        max(convert_timezone('UTC', 'America/Halifax', f.value:"dateTime"::timestamp_ntz)) over () as max_date_time,
        current_date as currentdate
    from source,
        lateral flatten(input => source.json_data:"items") as f
)

select * from items
