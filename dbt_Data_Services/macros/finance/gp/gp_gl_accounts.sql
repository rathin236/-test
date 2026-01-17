{# macros/gp_gl_accounts.sql #}

{% macro render_gp_gl_accounts_for(schema_code) %}
 {% set raw_db = var('gp_raw_db', 'gp') %}

{% set sc_l = schema_code | lower %}
{% set sc_u = schema_code | upper %}

with account_desc as (
  select *
  from {{ raw_db }}.{{ sc_u }}.gl00100
),

account_number as (
  select *
  from {{ raw_db }}.{{ sc_u }}.gl00105
),

gl_balance as (
  select {{ trim_columns_int('int_vendor_spend__gp__ledger_vouchers') }}
  from {{ ref('int_vendor_spend__gp__ledger_vouchers') }}
  where company_id = upper(replace('{{ sc_u }}', '_DBO', ''))
),

/* normalize the join key to NUMBER to avoid type mismatch nulls */
gl_accounts as (
  select distinct
         cast(gl_account_id as number) as actindx_num
  from gl_balance
  where gl_account_id is not null
),

renamed as (
  select
    /* keep names the same as your original */
    trim(cast(gl_accounts.actindx_num as varchar))            as gl_account_id,
    trim(account_number.actnumst)                             as gl_account_number,
    substring(trim(account_number.actnumst), 0, 5)            as act_num,
    trim(upper(account_desc.actdescr))                        as gl_account_description,
    upper(replace('{{ sc_u }}', '_DBO', '')) as company_id,
    md5(concat(upper(replace('{{ sc_u }}', '_DBO', '')), trim(cast(gl_accounts.actindx_num as varchar)))) as sk_gl_account_global
  from gl_accounts
  left join account_desc
    on gl_accounts.actindx_num = cast(account_desc.actindx as number)
  left join account_number
    on gl_accounts.actindx_num = cast(account_number.actindx as number)
)

select *
from renamed

{% endmacro %}
