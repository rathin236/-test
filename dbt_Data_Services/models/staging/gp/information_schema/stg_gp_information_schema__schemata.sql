with source as (

    select * from {{ source('gp_information_schema', 'schemata') }}

),

renamed as (

    select
        catalog_name,
        schema_name,
        schema_owner,
        is_transient,
        is_managed_access,
        retention_time,
        default_character_set_catalog,
        default_character_set_schema,
        default_character_set_name,
        sql_path,
        created,
        last_altered,
        comment,
        lower(replace(schema_name, '_DBO', '')) as schema_name_modified

    from source

)

select

    catalog_name,
    schema_name,
    schema_owner,
    is_transient,
    is_managed_access,
    retention_time,
    default_character_set_catalog,
    default_character_set_schema,
    default_character_set_name,
    sql_path,
    created,
    last_altered,
    comment,
    schema_name_modified,
    'stg_gp_' || schema_name_modified || '__gl20000' as gl20000

from renamed

where schema_name not in ('INFORMATION_SCHEMA', 'PUBLIC', 'FIVETRAN_GROPING_OBTAINING_STAGING')

order by schema_name_modified
