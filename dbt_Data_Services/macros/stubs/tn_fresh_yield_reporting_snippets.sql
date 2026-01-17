{{ codegen.generate_model_yaml(
    upstream_descriptions = True,
    model_names = [
        'int_tn_fresh_yield_reporting__dim_item_innova',
        'int_tn_fresh_yield_reporting__dim_item_ns',
        'int_tn_fresh_yield_reporting__dim_production_line_innova',
        'int_tn_fresh_yield_reporting__dim_production_line_ns',
        'int_tn_fresh_yield_reporting__processing_inputs_innova',
        'int_tn_fresh_yield_reporting__processing_inputs_ns',
        'int_tn_fresh_yield_reporting__processing_outputs_cases',
        'int_tn_fresh_yield_reporting__processing_outputs_pallets',
        'int_tn_fresh_yield_reporting__processing_outputs_qc'
        ]
) }}

{{ codegen.generate_model_yaml(
    upstream_descriptions = True,
    model_names = [
        'tn_fresh_dim_item',
        'tn_fresh_dim_lot',
        'tn_fresh_dim_processing_company',
        'tn_fresh_dim_production_line',
        'tn_fresh_dim_sales_order',
        'tn_fresh_fact_processing_inputs',
        'tn_fresh_fact_processing_outputs'
        ]
) }}