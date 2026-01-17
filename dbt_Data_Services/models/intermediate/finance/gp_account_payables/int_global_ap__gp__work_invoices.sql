-- models/intermediate/finance/gp_account_payables/int_global_ap__gp__open_invoices.sql
-- noqa: disable=all
{{ config(materialized='table') }}

-- parse-time anchors
-- depends_on: {{ ref('stg_gp__company_name') }}
-- depends_on: {{ ref('dim__daily_exchange_rates') }}
-- depends_on: {{ ref('int_global_ap__gp__valid_schemas') }}

{% set schema_list = dbt_utils.get_column_values(
    table=ref('int_global_ap__gp__valid_schemas'),
    column='table_schema'
) %}

with all_open_invoices as (

    {% if schema_list | length == 0 %}

    -- Hard guard: no eligible schemas found
    select
        cast(null as varchar) as company,
        cast(null as varchar) as company_currency,
        cast(null as varchar) as vendor_class_id,
        cast(null as varchar) as vendor_id,
        cast(null as varchar) as vendor_name
    where 1 = 0

    {% else %}

    {% for schema in schema_list %}
    select * from ( {{ render_gp_work_ap_for(schema) }} )
    {% if not loop.last %} union all {% endif %}
    {% endfor %}

    {% endif %}

)

select
    *
from all_open_invoices
