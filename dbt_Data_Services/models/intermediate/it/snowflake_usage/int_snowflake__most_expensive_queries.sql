{{
    config(
        materialized='incremental',
        unique_key =['query_id', 'start_time']
    )
}}

with reader_account_queries as (

    select

        reader_account_name as account_locator,
        query_id,
        query_text,
        database_id,
        schema_name,
        query_type,
        --user_name,
        --role_name,
        warehouse_id,
        warehouse_name,
        warehouse_size,
        warehouse_type,
        cluster_number,
        execution_status,
        start_time,
        --percentage_scanned_from_cache,
        --bytes_written,
        rows_produced,
        compilation_time,
        execution_time,
        total_elapsed_time,
        credits_used_cloud_services,
        extract(year from to_date(start_time)) as year,
        extract(month from to_date(start_time)) as month,
        rank() over (
            partition by
                account_locator,
                warehouse_id,
                extract(year from to_date(start_time)), extract(month from to_date(start_time))
            order by credits_used_cloud_services desc
        ) as credit_rank

    from {{ ref('stg_snowflake_reader_account_usage__query_history') }}

    -- only check results from last day
    {% if is_incremental() %}

        where
            start_time
            > dateadd(day, -1, (select max(start_time) from {{ this }}))

    {% endif %}

),

main_account_queries as (

    select

        'YJ63875' as account_locator,
        query_id,
        query_text,
        database_id,
        schema_name,
        query_type,
        --user_name,
        --role_name,
        warehouse_id,
        warehouse_name,
        warehouse_size,
        warehouse_type,
        cluster_number,
        execution_status,
        start_time,
        --percentage_scanned_from_cache,
        --bytes_written,
        rows_produced,
        compilation_time,
        execution_time,
        total_elapsed_time,
        credits_used_cloud_services,
        extract(year from to_date(start_time)) as year,
        extract(month from to_date(start_time)) as month,
        rank() over (
            partition by
                warehouse_id,
                extract(year from to_date(start_time)), extract(month from to_date(start_time))
            order by credits_used_cloud_services desc
        ) as credit_rank

    from {{ ref('stg_snowflake_account_usage__query_history') }}

    -- only check results from last day
    {% if is_incremental() %}

        where
            start_time
            > dateadd(day, -1, (select max(start_time) from {{ this }}))

    {% endif %}

)

select * from reader_account_queries
where credit_rank <= 50
union all
select * from main_account_queries
where credit_rank <= 50
