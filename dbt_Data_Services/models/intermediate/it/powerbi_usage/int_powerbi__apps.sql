with filtered_data as (
    select *
    from {{ ref('stg_powerbi__apps') }}
    qualify
        _fivetran_batch = max(_fivetran_batch) over ()
),

parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        parse_json(json_data):description::string as description,
        parse_json(json_data):id::string as id,
        parse_json(json_data):lastUpdate::timestamp as lastupdate,
        parse_json(json_data):name::string as name,
        parse_json(json_data):publishedBy::string as publishedby,
        parse_json(json_data):users::array as users,
        parse_json(json_data):workspaceId::string as workspaceid,
        dateadd(day, -1, create_date) as last_check_date
    from filtered_data
)

select * from parsed_data
