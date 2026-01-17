{{ config(materialized='table') }}
-- parse-time anchors
-- depends_on: {{ ref('stg_gp__company_name') }}
-- depends_on: {{ ref('int_vendor_spend__gp__ledger_vouchers') }}

{% set schema_list = dbt_utils.get_column_values(
    table=ref('int_gp_ledger__valid_schemas'),
    column='table_schema'
) %}

with gl_accounts_union as (

    {% if schema_list | length == 0 %}
        -- Hard guard: no eligible schemas found
        select
            cast(null as varchar) as company_id,
            cast(null as varchar) as gl_account_id,
            cast(null as varchar) as gl_account_name
        where 1 = 0

    {% else %}

        {% for s in schema_list %}
        select * from ( {{ render_gp_gl_accounts_for(s) }} )
        {% if not loop.last %} union all {% endif %}
        {% endfor %}

    {% endif %}

)

select *
from gl_accounts_union
