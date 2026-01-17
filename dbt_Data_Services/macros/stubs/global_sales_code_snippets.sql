{{ codegen.generate_model_yaml(

    model_names=['dim_site_ns',
                'dim_warehouse_ns']
) }}

{{ codegen.generate_model_yaml(
    model_names=['dim_salesperson_ns']
) }}

{{ codegen.generate_model_yaml(
    model_names=['dim_invoice_accounts_ns']
) }}

{{ codegen.generate_source(
    schema_name = 'information_schema',
    database_name = 'gp',
    table_names = ['schemata'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'finops_adls',
    database_name = 'd365',
    table_names = ['invent_location_logistics_location'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'finops_adls',
    database_name = 'd365',
    table_names = ['invent_site_logistics_location'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'xref',
    database_name = 'staging_prod',
    table_names = ['currency_exchange_rates'],
    generate_columns = True,
    include_descriptions = True) }}
    
{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_soinvoiceheader'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_mfcurrency'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_mfpaymentterms'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_soorderstatus'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_mfsite'],
    generate_columns = True,
    include_descriptions = True) }}


{{ codegen.generate_source('d365.finops_adls') }}

-- NorthScope
dbt run-operation generate_source --args '{"schema_name": "nsce_dbo", "database_name": "northscope_coolearth", "table_names":["erpx_arcustomer", "erpx_arcustomeraddress"], "generate_columns": "True", "include_descriptions": "True"}'

-- D365
dbt run-operation generate_source --args '{"schema_name": "finops_adls", "database_name": "d365", "table_names":["logistics_postal_address", "logistics_address_country_region", "logistics_location", "cust_table", "dir_party_table"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "finops_adls", "database_name": "d365", "table_names":["dir_party_location"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "finops_adls", "database_name": "d365", "table_names":["eco_res_attribute", "eco_res_value", "eco_res_product_translation", "invent_item_group_item", "invent_item_group", "eco_res_attribute_value", "eco_res_instance_value"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "finops_adls", "database_name": "d365", "table_names":["invent_location", "invent_site"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "finops_adls", "database_name": "d365", "table_names":["fdsenumtable"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "calendar", "database_name": "ancillary", "table_names":["\"Calendar\""], "generate_columns": "True", "include_descriptions": "True"}'

{{ codegen.generate_model_yaml(
    model_names=['stg_d365__cust_invoice_trans', 'stg_d365__cust_table']
) }}

-- staging models for d365
{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='docu_ref'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='dimension_attribute'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='dimension_attribute_value'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='dimension_attribute_value_set_item'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='unitofmeasure'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='unitofmeasureconversion'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='exchange_rate'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='exchange_rate_currency_pair'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='cust_invoice_trans'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_dim'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='retail_sales_line'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_trans_origin'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='sales_table'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='sales_line'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='pds_rebate_table'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_sum'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_settlement'
) }}

{{ codegen.generate_base_model(
    source_name='ancillary',
    table_name='"Calendar"'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_trans'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='fdsenumtable'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_location'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_site'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_instance_value'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_attribute_value'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_item_group'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_attribute'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_value'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_product'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='eco_res_product_translation'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_item_group_item'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='logistics_postal_address'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='logistics_location'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='logistics_address_country_region'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='cust_table'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='dir_party_table'
) }}

{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='dir_party_location'
) }}

{{ codegen.generate_model_import_ctes(
    model_name = 'stg_global_sales__logistics_postal_address'
) }}

<<<<<<< HEAD
{{ codegen.generate_source(
    schema_name = 'finops_adls',
    database_name = 'd365',
    table_names = ['cust_invoice_jour'],
    generate_columns = True,
    include_descriptions = True) }}
=======
{{ codegen.generate_base_model(
    source_name='finops_adls',
    table_name='invent_batch'
) }}
>>>>>>> 969c05b38768e1256ec8c1ba5f05321342b7e120
