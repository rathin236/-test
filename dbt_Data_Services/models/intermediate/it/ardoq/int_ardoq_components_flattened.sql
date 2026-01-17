with maxcreatedate as (
    select max(create_date) as max_create_date
    from {{ ref('stg_ardoq__components') }}
),

base as (
    select
        transactionid,
        modified_date,
        create_date,
        json_data
    from {{ ref('stg_ardoq__components') }}
    inner join maxcreatedate on create_date = maxcreatedate.max_create_date
),

main as (
    select
        modified_date,
        create_date,
        json_data.value:_id::string as id,
        json_data.value:_meta:created::string as created_timestamp,
        json_data.value:_meta:createdBy::string as created_by,
        json_data.value:_meta:createdByEmail::string as created_by_email,
        json_data.value:_meta:createdByName::string as created_by_name,
        json_data.value:_meta:lastModifiedBy::string as last_modified_by,
        json_data.value:_meta:lastModifiedByEmail::string as last_modified_by_email,
        json_data.value:_meta:lastModifiedByName::string as last_modified_by_name,
        json_data.value:_meta:lastUpdated::timestamp as last_updated_timestamp,
        json_data.value:_version::integer as version_,
        json_data.value:color::string as color,
        json_data.value:componentKey::string as component_key,
        json_data.value:customFields:approval_status::string as approval_status,
        json_data.value:customFields:integration_type::string as integration_type,
        json_data.value:customFields:maturity::string as maturity,
        json_data.value:customFields:approved::string as approved,
        json_data.value:customFields:capability_id::string as capability_id,
        json_data.value:customFields:component_level::string as component_level,
        json_data.value:customFields:live_end_date::string as live_end_date,
        json_data.value:customFields:live_start_date::string as live_start_date,
        json_data.value:customFields:top_level_parent::string as top_level_parent,
        json_data.value:description::string as description,
        json_data.value:icon::string as icon,
        json_data.value:image::string as image,
        json_data.value:name::string as comp_name,
        json_data.value:parent::string as parent,
        json_data.value:rootWorkspace::string as root_workspace,
        json_data.value:shape::string as shape,
        json_data.value:type::string as component_type,
        json_data.value:typeId::string as type_id
    from base,
        lateral flatten(input => parse_json(base.json_data:values)) as json_data
)

select * from main
