{{ codegen.generate_source(
    schema_name = 'ppm',
    database_name = 'staging_prod',
    table_names = ['entity_portfolio','entity_project','entity_request','entity_resource','entity_task','entity_taskschedule','entities_fields','resourcecapacity','entity_user','timesheetforuser','userallocationhours','demandcapacity'],
    generate_columns = True,
    include_descriptions = True) }}  