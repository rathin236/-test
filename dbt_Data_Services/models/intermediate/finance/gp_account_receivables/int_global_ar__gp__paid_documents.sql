{{ config(materialized='table') }}
-- parse-time anchors
-- depends_on: {{ ref('stg_gp__company_name') }}
-- depends_on: {{ ref('dim__daily_exchange_rates') }}
-- depends_on: {{ ref('int_global_ar__gp__valid_schemas') }}
-- depends_on: {{ ref('int_global_ar__gp_document_type') }}
-- depends_on: {{ ref('int_global_ar__gp_customer_credit_limit_type') }}

{% set schema_list = dbt_utils.get_column_values(
    table=ref('int_global_ar__gp__valid_schemas'),
    column='table_schema'
) %}

with all_paid_ar as (

    {% if schema_list | length == 0 %}
    -- Hard guard: no eligible schemas found
    select
        cast(null as varchar) as company_id,
        cast(null as varchar) as customer_id,
        cast(null as varchar) as document_number
    where 1 = 0

    {% else %}
    {% for schema in schema_list %}
    select * from ( {{ render_gp_paid_ar_for(schema) }} )
    {% if not loop.last %} union all {% endif %}
    {% endfor %}
    {% endif %}

)

select *
from all_paid_ar
