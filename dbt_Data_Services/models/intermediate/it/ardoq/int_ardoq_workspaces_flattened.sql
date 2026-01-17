with maxcreatedate as (
    select max(create_date) as max_create_date
    from {{ ref('stg_ardoq__workspaces') }}
),

base as (
    select
        transactionid,
        modified_date,
        create_date,
        json_data
    from {{ ref('stg_ardoq__workspaces') }}
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
        json_data.value:description::string as description,
        json_data.value:name::string as wp_name,
        json_data.value:startView::string as start_view,
        json_data.value:workspaceKey::string as workspace_key
    from base,
        lateral flatten(input => parse_json(base.json_data:values)) as json_data
)

select * from main
