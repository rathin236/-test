with filtered_data as (
    select *
    from {{ ref('stg_powerbi__activities') }}
    where parse_json(json_data):Activity::string = 'ViewReport'
    qualify
        rank() over (partition by transactionid order by _fivetran_batch desc) = 1
),

parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        json_data as payload,
        create_date,
        parse_json(json_data):Activity::string as activity,
        parse_json(json_data):ActivityId::string as activityid,
        parse_json(json_data):AppId::string as appid,
        parse_json(json_data):ArtifactId::string as artifactid,
        parse_json(json_data):ArtifactKind::string as artifactkind,
        parse_json(json_data):ArtifactName::string as artifactname,
        parse_json(json_data):ClientIP::string as clientip,
        parse_json(json_data):ConsumptionMethod::string as consumptionmethod,
        parse_json(json_data):CreationTime::timestamp as creationtime,
        parse_json(json_data):DatasetId::string as datasetid,
        parse_json(json_data):DatasetName::string as datasetname,
        parse_json(json_data):DistributionMethod::string as distributionmethod,
        parse_json(json_data):Id::string as id,
        parse_json(json_data):IsSuccess::boolean as issuccess,
        parse_json(json_data):ItemName::string as itemname,
        parse_json(json_data):Operation::string as operation,
        parse_json(json_data):OrganizationId::string as organizationid,
        parse_json(json_data):RecordType::int as recordtype,
        parse_json(json_data):RefreshEnforcementPolicy::int as refreshenforcementpolicy,
        parse_json(json_data):ReportId::string as reportid,
        parse_json(json_data):ReportName::string as reportname,
        parse_json(json_data):UserAgent::string as useragent,
        parse_json(json_data):UserId::string as userid,
        parse_json(json_data):UserKey::string as userkey,
        parse_json(json_data):UserType::int as usertype,
        parse_json(json_data):WorkSpaceName::string as workspacename,
        parse_json(json_data):Workload::string as workload,
        parse_json(json_data):WorkspaceId::string as workspaceid,
        dateadd(day, -1, create_date) as activity_date
    from filtered_data
)

select * from parsed_data
