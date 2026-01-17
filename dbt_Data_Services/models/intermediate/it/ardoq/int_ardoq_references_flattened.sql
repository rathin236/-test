with maxcreatedate as (
    select max(create_date) as max_create_date
    from {{ ref('stg_ardoq__references') }}
),

base as (
    select
        transactionid,
        modified_date,
        create_date,
        json_data
    from {{ ref('stg_ardoq__references') }}
    inner join maxcreatedate on create_date = maxcreatedate.max_create_date
),

main as (
    select
        modified_date,
        create_date,
        json_data.value:_id::string as id,
        json_data.value:_meta:created::timestamp as created_timestamp,
        json_data.value:_meta:createdBy::string as created_by,
        json_data.value:_meta:createdByEmail::string as created_by_email,
        json_data.value:_meta:createdByName::string as created_by_name,
        json_data.value:_meta:lastModifiedBy::string as last_modified_by,
        json_data.value:_meta:lastModifiedByEmail::string as last_modified_by_email,
        json_data.value:_meta:lastModifiedByName::string as last_modified_by_name,
        json_data.value:_meta:lastUpdated::timestamp as last_updated_timestamp,
        json_data.value:_version::integer as version_,
        json_data.value:customFields:business_level_maturity::string as business_level_maturity,
        json_data.value:customFields:application_url::string as application_url,
        json_data.value:customFields:connection_type::string as connection_type,
        json_data.value:customFields:capability_team_role::string as capability_team_role,
        json_data.value:rootWorkspace::string as root_workspace,
        json_data.value:source::string as source,
        json_data.value:target::string as target,
        json_data.value:targetWorkspace::string as target_workspace,
        json_data.value:type::integer as ref_type
    from base,
        lateral flatten(input => parse_json(base.json_data:values)) as json_data
)

select * from main
