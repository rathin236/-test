{{ config(
    cluster_by=['site_id', 'unit_id']
) }}

with source as (
    select parse_json(json_data) as json_data
    from {{ ref('stg_scale_aq__site') }}
),

silos as (
    select
        source.json_data:"siteId"::number as site_id,
        null as unit_id,
        'silo' as data_type,
        s.value:"siloName"::string as measurement,
        s.value:"siloId"::number as silo_id,
        s.value:"capacity"::number as capacity_value,
        convert_timezone('UTC', 'America/Halifax', current_timestamp()) as date_time,
        max(convert_timezone('UTC', 'America/Halifax', current_timestamp())) over () as max_date_time,
        current_date as currentdate
    from source,
        lateral flatten(input => source.json_data:"silos") as s  -- JSON flattening
),

units as (
    select
        source.json_data:"siteId"::number as site_id,
        u.value:"unitId"::number as unit_id,
        'unit' as data_type,
        u.value:"unitName"::string as measurement,
        null as silo_id,
        0.0 as capacity_value,
        convert_timezone('UTC', 'America/Halifax', current_timestamp()) as date_time,
        max(convert_timezone('UTC', 'America/Halifax', current_timestamp())) over () as max_date_time,
        current_date as currentdate
    from source,
        lateral flatten(input => source.json_data:"units") as u  -- JSON flattening
)

select * from silos
union all
select * from units
