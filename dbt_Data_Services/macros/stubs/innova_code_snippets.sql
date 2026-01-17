{{ codegen.generate_source(
    schema_name = 'tns_fbd_fbdag_dbo',
    database_name = 'innova',
    table_names = ['proc_lots'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'tns_fbd_fbdag_dbo',
    database_name = 'innova',
    table_names = ['proc_matxacts',
                    'proc_plots',
                    'proc_materials'],
    generate_columns = True,
    include_descriptions = True) }}