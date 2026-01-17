{{ codegen.generate_source(schema_name = 'finops_adls', 
database_name = 'd365',
table_names = ['cust_packing_slip_trans', 'cust_invoice_packing_slip_quantity_match'],
generate_columns = True,
include_descriptions = True) }} 

{{ codegen.generate_source(schema_name = 'finops_adls',
    database_name = 'd365',
    table_names = ['vend_invoice_jour','ledger_journal_trans','main_account_category','ledger_journal_table', 'dimension_attribute_value_combination'],
    generate_columns = True,
    include_descriptions = True
    ) 
}}  

{{ codegen.generate_model_yaml(
    model_names=['int_d365__vendor_account_name',
                 'int_d365__posting_type',
                 'int_d365__main_account_type_vw',
                 'int_d365__main_account_table',
                 'int_d365__general_journal_entries']
) 
}}    

{{ codegen.generate_model_yaml(
    model_names=['d365__v_it_costs']
) 
}} 
