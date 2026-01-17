{{ codegen.generate_source(
    schema_name = 'ardoq',
    database_name = 'staging_prod',
    table_names = ['components','references','workspaces'],
    generate_columns = True,
    include_descriptions = True) }}