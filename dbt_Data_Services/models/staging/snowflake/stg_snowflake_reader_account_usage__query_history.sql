with

source as (

    select *
    from {{ source('snowflake_reader_account_usage', 'query_history') }}

),

renamed as (

    select
        reader_account_name,
        query_id,
        query_text,
        query_type,
        session_id,
        user_name,
        role_name,
        schema_id,
        schema_name,
        database_id,
        database_name,
        warehouse_id,
        warehouse_name,
        warehouse_size,
        warehouse_type,
        cluster_number,
        query_tag,
        execution_status,
        error_code,
        error_message,
        start_time,
        end_time,
        total_elapsed_time,
        bytes_scanned,
        rows_produced,
        compilation_time,
        execution_time,
        queued_provisioning_time,
        queued_repair_time,
        queued_overload_time,
        transaction_blocked_time,
        outbound_data_transfer_cloud,
        outbound_data_transfer_region,
        outbound_data_transfer_bytes,
        inbound_data_transfer_cloud,
        inbound_data_transfer_region,
        inbound_data_transfer_bytes,
        list_external_files_time,
        credits_used_cloud_services,
        reader_account_deleted_on

    from source

)

select * from renamed
