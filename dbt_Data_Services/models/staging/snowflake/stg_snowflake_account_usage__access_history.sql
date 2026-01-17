with

source as (

    select * from {{ source('snowflake_account_usage', 'access_history') }}

),

renamed as (

    select
        query_id,
        query_start_time,
        user_name,
        direct_objects_accessed,
        base_objects_accessed,
        objects_modified,
        object_modified_by_ddl,
        policies_referenced

    from source

)

select * from renamed
