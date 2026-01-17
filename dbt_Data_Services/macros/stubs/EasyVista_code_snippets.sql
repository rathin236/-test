{{ codegen.generate_source(
    schema_name = 'easyvista',
    database_name = 'staging_prod',
    table_names = ['tickets','root_cause','work_group','urgency','impacts','tickets_action'],
    generate_columns = True,
    include_descriptions = True) }}