with filtered_data as (
    select *
    from {{ ref('stg_powerbi__groups') }}
    qualify
        _fivetran_batch = max(_fivetran_batch) over ()
),

parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        parse_json(json_data):capacityMigrationStatus::string as capacitymigrationstatus,
        parse_json(json_data):hasWorkspaceLevelSettings::boolean as hasworkspacelevelsettings,
        parse_json(json_data):id::string as id,
        parse_json(json_data):isOnDedicatedCapacity::boolean as isondedicatedcapacity,
        parse_json(json_data):isReadOnly::boolean as isreadonly,
        parse_json(json_data):name::string as name,
        parse_json(json_data):state::string as state,
        parse_json(json_data):type::string as type,
        dateadd(day, -1, create_date) as last_check_date
    from filtered_data
)

select * from parsed_data
