with

source as (

    select *
    from {{ source('snowflake_account_usage', 'serverless_task_history') }}

),

renamed as (

    select
        start_time,
        end_time,
        credits_used,
        task_id,
        task_name,
        schema_id,
        schema_name,
        database_id,
        database_name

    from source

)

select * from renamed
