with

source as (

    select * from {{ source('gp_information_schema', 'tables') }}

),

renamed as (

    select
        table_catalog,
        table_schema,
        table_name,
        table_owner,
        table_type,
        is_transient,
        clustering_key,
        row_count,
        bytes,
        retention_time,
        self_referencing_column_name,
        reference_generation,
        user_defined_type_catalog,
        user_defined_type_schema,
        user_defined_type_name,
        is_insertable_into,
        is_typed,
        commit_action,
        created,
        last_altered,
        last_ddl,
        last_ddl_by,
        auto_clustering_on,
        comment,
        is_temporary,
        is_iceberg,
        is_dynamic,
        is_immutable,
        is_hybrid,
        lower(replace(table_schema, '_DBO', '')) as schema_name

    from source

)

select * from renamed
