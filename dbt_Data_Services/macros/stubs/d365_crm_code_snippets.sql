{{ codegen.generate_source(
    schema_name = 'finops_adls',
    database_name = 'd365',
    table_names = ['invent_table_module'],
    generate_columns = True,
    include_descriptions = True) }}  

{{ codegen.generate_source(
    schema_name = 'finops_adls_crp',
    database_name = 'd365',
    table_names = ['invent_table_module', 'eco_res_product' , 'eco_res_product_translation'],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
    schema_name = 'finops_adls_crp',
    database_name = 'd365',
    table_names = ['cust_table', 'dir_party_table' , 'dir_person_name', 'dir_party_location', 'dir_party_postal_address_view'],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
schema_name = 'finops_adls_crp',
database_name = 'd365',
table_names = ['INVENT_ITEM_GROUP_ITEM'],
generate_columns = True,
include_descriptions = True) }}  

staging_dev.d365_ce.user_alias

{{ codegen.generate_source(
    schema_name = 'd365_ce',
    database_name = 'staging_dev',
    table_names = ['user_alias'],
    generate_columns = True,
    include_descriptions = True) }} 

{{ codegen.generate_source(
    schema_name = 'finops_adls_crp',
    database_name = 'd365',
    table_names = ['pricelevel'],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
    schema_name = 'crm_dev3',
    database_name = 'd365',
    table_names = [ 'pricelevel','transactioncurrency', 'account' , 'systemuser' ],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
    schema_name = 'd365_ce',
    database_name = 'staging_dev',
    table_names = [ 'xref_customers' ],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
    schema_name = 'crm_dev3',
    database_name = 'd365',
    table_names = [ 'productpricelevel' ],
    generate_columns = True,
    include_descriptions = True) }}  


{{ codegen.generate_source(
    schema_name = 'crm_dev3',
    database_name = 'd365',
    table_names = [ 'opportunity', 'systemuser','team' ],
    generate_columns = True,
    include_descriptions = True) }}  




{{ codegen.generate_model_yaml(
    model_names=['stg_crm_dev3__product', 'stg_crm_dev3__uomschedule' ]
) }}


{{ codegen.generate_model_yaml(
    model_names=['int_d365_crm__crm_importcustomers','int_d365_crm__crm_new_product_price_list','int_d365_crm__crm_product_price_list', 'int_d365_crm__crmcustomer', 'int_d365_crm__crmproduct', 'int_d365_crm__crmunits', 'int_d365_crm__crmuom', 'int_d365_crm__crmuom', 'int_d365_crm__d365_importcustomers', 'int_d365_crm__d365customer', 'int_d365_crm__d365units', 'int_d365_crm__importdata_unit_groups']
) }}


{{ codegen.generate_base_model('CRM_DEV3','D365', 'STRINGMAP') }}

{{ codegen.generate_model_yaml(model_names=['d365_crm__v_product_price_lists', 'd365_crm__v_product_unit_groups', 'd365_crm__v_product_units' ])}}


{{ codegen.generate_model_yaml(
    model_names=['int_d365_crm__crm_importcustomers','int_d365_crm__crm_new_product_price_list','int_d365_crm__crm_product_price_list', 'int_d365_crm__crmcustomer', 'int_d365_crm__crmproduct', 'int_d365_crm__crmunits', 'int_d365_crm__crmuom', 'int_d365_crm__crmuom', 'int_d365_crm__d365_importcustomers', 'int_d365_crm__d365customer', 'int_d365_crm__d365units', 'int_d365_crm__importdata_unit_groups']
) }}



{{ codegen.generate_model_yaml(
    model_names=['stg_finops_adls_crp__cust_table' , 'stg_finops_adls_crp__dir_party_location','stg_finops_adls_crp__dir_party_postal_address_view', 'stg_finops_adls_crp__dir_party_table', 'stg_finops_adls_crp__dir_person_name', 'stg_finops_adls_crp__eco_res_product', 'stg_finops_adls_crp__eco_res_product_translation', 'stg_finops_adls_crp__invent_table', 'stg_finops_adls_crp__invent_table_module' , 'stg_finops_adls_crp__unit_of_measure', 'stg_finops_adls_crp__unit_of_measure_conversion' ]
) }}

{{ codegen.generate_source(
    schema_name = 'finops_adls_crp',
    database_name = 'd365',
    table_names = ['HCMWORKER'],
    generate_columns = True,
    include_descriptions = True) }}  

{{ codegen.generate_source(
    schema_name = 'd365_ce',
    database_name = 'STAGING_DEV',
    table_names = ['user_alias'],
    generate_columns = True,
    include_descriptions = True) }}  