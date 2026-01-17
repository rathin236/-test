{{ codegen.generate_source(
    schema_name = 'raw_usage',
    database_name = 'powerbi',
    table_names = ['raw_activities', 'raw_apps','raw_datasets','raw_reports','raw_workspaces'],
    generate_columns = True,
    include_descriptions = True) }}