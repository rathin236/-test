{{ codegen.generate_source(
    schema_name = 'CAI_DATA_STORE_SHAREPOINT_DBO',
    database_name = 'COOKEINC_REPORTSERVER',
    table_names = ['TNS_LOTDOWNGRADE_MASTER_ARCHIVE20240711', 'TNS_LOTDOWNGRADE_MASTER'],
    generate_columns = True,
    include_descriptions = True) }}  
