dbt run-operation generate_source --args '{"schema_name": "nsce_dbo", "database_name": "northscope_coolearth", "table_names":["ERPx_SOOrderHeader", "ERPx_SOOrderItem", "ERPx_ARCustomer", "ERPx_ARCustomerAddress", "ERPx_ARCustomerAddressAttribute", "ERPx_MFDataEntityCompany", "ERPx_MFAttributeValue", "ERPx_IMItem", "ERPx_IMUOM", "ERPx_ARCustomerFavorite", "ERPx_ARCustomerSubstituteItem", "ERPx_IMUOMScheduleConversionValue", "ERPx_SOCarrier", "VWx_IMItemAttributeValues"], "generate_columns": "True", "include_descriptions": "True"}'
dbt run-operation generate_source --args '{"schema_name": "nsce_dbo", "database_name": "northscope_coolearth", "table_names":["ERPx_MFAttribute"], "generate_columns": "True", "include_descriptions": "True"}'

-- Cant get the upstream descriptions to work. I suspect it has something to do with case sensitivity
dbt run-operation generate_model_yaml --args '{"model_names": ["stg_northscope__erpx_so_order_header"], upstream_descriptions: true}'
{{ codegen.generate_model_yaml(
    upstream_descriptions = True,
    model_names = ['stg_northscope__erpx_so_order_header',
                    'stg_northscope__erpx_so_order_item'
                    ]
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imitemsetitems'
) }}

{{ codegen.generate_model_yaml(
    upstream_descriptions=True,
    model_names = ['stg_northscope__erpx_ar_customer', 
                    'stg_northscope__erpx_ar_customer_address',
                    'stg_northscope__erpx_ar_customer_address_attribute',
                    'stg_northscope__erpx_ar_customer_favorite',
                    'stg_northscope__erpx_ar_customer_substitute_item',
                    'stg_northscope__erpx_im_item',
                    'stg_northscope__erpx_im_item_attributes',
                    'stg_northscope__erpx_im_item_class',
                    'stg_northscope__erpx_im_item_type',
                    'stg_northscope__erpx_im_uom',
                    'stg_northscope__erpx_im_uom_schedule',
                    'stg_northscope__erpx_im_uom_schedule_conversion_value',
                    'stg_northscope__erpx_mf_attribute',
                    'stg_northscope__erpx_mf_attribute_class',
                    'stg_northscope__erpx_mf_attribute_value',
                    'stg_northscope__erpx_mf_data_entity_company',
                    'stg_northscope__erpx_so_carrier',
                    'stg_northscope__erpx_so_order_header',
                    'stg_northscope__erpx_so_order_item'
                    ]
) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['ERPx_IMItemSetItems'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_imitemset'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wmproductionlinedef'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wmlotfarm'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wms_lot_tbl'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_sosalesperson'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wms_contty_tbl'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['erpx_imattributevalues'],
    generate_columns = True,
    include_descriptions = True) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['ERPx_IMItemClass', 'ERPx_IMItemType', 'ERPx_IMUOMSchedule', 'ERPx_IMItemAttributes', 'ERPx_MFAttributeClass', 'ERPx_IMUOM'],
    generate_columns = True,
    include_descriptions = True) }}

-- ERPx_SOOrderHeader x
-- ERPx_SOOrderItem x
-- ERPx_ARCustomer x
-- ERPx_ARCustomerAddress x
-- ERPx_ARCustomerAddressAttribute x
-- ERPx_MFDataEntityCompany x
-- ERPx_MFAttribute x
-- ERPx_MFAttributeValue x
-- ERPx_IMItem x
-- ERPx_IMUOM x
-- ERPx_ARCustomerFavorite x
-- ERPx_ARCustomerSubstituteItem x
-- ERPx_IMUOMScheduleConversionValue x
-- ERPx_SOCarrier x
-- VWx_IMItemAttributeValues
    -- ERPx_IMItem x
    -- ERPx_MFDataEntityCompany x
    -- ERPx_IMItemClass x
    -- ERPx_IMItemType x
    -- ERPx_IMUOMSchedule x
    -- ERPx_IMItemAttributes x
    -- ERPx_MFAttribute x
    -- ERPx_MFAttributeClass x
    -- ERPx_MFAttributeValue x
    -- ERPx_IMUOM x

-- wms_contdtl_tbl
-- wms_contcase_tbl
-- wms_conthdr_tbl
-- wmGiveAway
-- create a small xref table for EDI 856 warehouses - FBD and PECH

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wms_pmint_tbl'],
    generate_columns = True,
    include_descriptions = True,
    name = 'coolearth') }}

-- coolearth
{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_contty_tbl'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_pmint_tbl'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_outint_tbl'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wmgiveaway'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_conthdr_tbl'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_contcase_tbl'
) }}

{{ codegen.generate_base_model(
    source_name='coolearth',
    table_name='wms_contdtl_tbl'
) }}

-- staging models for northscope
{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imuom'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_mfattributeclass'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imitemattributes'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imuomschedule'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imitemtype'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imitemclass'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_socarrier'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imuomscheduleconversionvalue'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_mfattribute'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_arcustomersubstituteitem'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_arcustomerfavorite'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imuom'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_imitem'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_mfattributevalue'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_mfdataentitycompany'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_arcustomeraddressattribute'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_arcustomeraddress'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_arcustomer'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_soorderitem'
) }}

{{ codegen.generate_base_model(
    source_name='northscope',
    table_name='erpx_soorderheader'
) }}

{{ codegen.generate_source(
    schema_name = 'nsce_dbo',
    database_name = 'northscope_coolearth',
    table_names = ['wms_bindtlst_tbl', 'VWx_IMItemAttributeValues','wms_lot_tbl'],
    generate_columns = True,
    include_descriptions = True) }}  