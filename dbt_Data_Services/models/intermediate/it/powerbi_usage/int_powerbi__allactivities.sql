with parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        json_data as payload,
        create_date,
        parse_json(json_data):CreationTime::string as creationtime,
        parse_json(json_data):Activity::string as activity,
        parse_json(json_data):ArtifactName::string as artifactname,
        parse_json(json_data):ArtifactKind::string as artifactkind,
        parse_json(json_data):ItemName::string as itemname,
        parse_json(json_data):UserId::string as userid,
        parse_json(json_data):ArtifactId::string as artifactid,
        dateadd(day, -1, create_date) as activity_date
    from {{ ref('stg_powerbi__activities') }}
)

select * from parsed_data
order by _fivetran_batch asc
