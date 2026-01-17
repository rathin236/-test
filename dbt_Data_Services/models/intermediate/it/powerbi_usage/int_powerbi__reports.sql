with filtered_data as (
    select *
    from {{ ref('stg_powerbi__reports') }}
    qualify
        _fivetran_batch = max(_fivetran_batch) over ()
),

parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        parse_json(json_data):appId::string as appid,
        parse_json(json_data):createdBy::string as createdby,
        parse_json(json_data):createdDateTime::timestamp as createddatetime,
        parse_json(json_data):datasetId::string as datasetid,
        parse_json(json_data):embedUrl::string as embedurl,
        parse_json(json_data):id::string as id,
        parse_json(json_data):modifiedBy::string as modifiedby,
        parse_json(json_data):modifiedDateTime::timestamp as modifieddatetime,
        parse_json(json_data):name::string as name,
        parse_json(json_data):originalReportObjectId::string as originalreportobjectid,
        parse_json(json_data):reportFlags::int as reportflags,
        parse_json(json_data):reportType::string as reporttype,
        parse_json(json_data):subscriptions::array as subscriptions,
        parse_json(json_data):users::array as users,
        parse_json(json_data):webUrl::string as weburl,
        parse_json(json_data):workspaceId::string as workspaceid,
        dateadd(day, -1, create_date) as last_check_date
    from filtered_data
)

select * from parsed_data
