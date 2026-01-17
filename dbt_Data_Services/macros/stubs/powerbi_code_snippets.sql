{{ codegen.generate_source(
    schema_name = 'raw_usage',
    database_name = 'powerbi',
    table_names = ['activities','apps','datasets','reports','groups'],
    generate_columns = True,
    include_descriptions = True) }}