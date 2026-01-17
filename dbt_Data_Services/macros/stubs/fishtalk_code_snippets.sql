{{ codegen.generate_model_yaml(['int_fishtalk__ext_mortality_causes_v2'])}}

{{ codegen.generate_model_yaml(['int_fishtalk__ext_daily_mortality_values_v2',
                                'int_fishtalk__ext_feed_delivery_v2',
                                'int_fishtalk__ext_feed_store_v2',
                                'int_fishtalk__ext_grouped_organisation_v2',
                                'int_fishtalk__ext_mortality_causes_v2',
                                'int_fishtalk__ext_mortality_status_values_v2',
                                'int_fishtalk__ext_organisation_groups_v2',
                                'int_fishtalk__ext_organisation_v2',
                                'int_fishtalk__ext_populations_v2',
                                'int_fishtalk__ext_stands_v2'
                                ])}}

{{ codegen.generate_model_yaml(['int_cpm_fishtalk__biological_fcr',
                                'int_cpm_fishtalk__generalized_growth_mortality_models',
                                'int_cpm_fishtalk__hatchery_spec_growth_models',
                                'int_cpm_fishtalk__production_overview',
                                'int_cpm_fishtalk__production_overview_adjusted'])}}

{{ codegen.generate_source(
    schema_name = 'cai_fishtalk_dbo',
    database_name = 'fishtalk',
    table_names = ['containers',
                    'organisationunit',
                    'publicstatusvalues',
                    'feedreceptions',
                    'feedreceptionbatches',
                    'feedbatch',
                    'feedstore',
                    'publicmortalitystatus',
                    'organisationunit',
                    'locations',
                    'county',
                    'organisationrelations',
                    'organisationunitproperties',
                    'populations',
                    'mortalitycauses',
                    'planpopulationstatus',
                    'sitecomponents'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'cai_fishtalk_dbo',
    database_name = 'fishtalk',
    table_names = ['stand'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'cai_fishtalk_dbo',
    database_name = 'fishtalk',
    table_names = ['mortalitycauses'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'cai_fishtalk_dbo',
    database_name = 'fishtalk',
    table_names = ['publictranslations'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'cai_fishtalk_dbo',
    database_name = 'fishtalk',
    table_names = ['feedreceptions',
                    'feedreceptionbatches',
                    'feedbatch'],
    generate_columns = True,
    include_descriptions = True) }}
