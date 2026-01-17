{# macros/gp_gl_accounts.sql #}

{% macro render_gp_dim_vendors_for(schema_code) %}
{% set raw_db = var('gp_raw_db', 'gp') %}

{% set sc_u = schema_code | upper %}
{% set sc_l = schema_code | lower %}

{% set company_id = sc_u | replace('_DBO', '') %}

with company as (
    select {{ trim_columns_int('stg_gp__company_name') }}
    from {{ ref('stg_gp__company_name') }}
    where trim(upper(interid)) = '{{ company_id }}'
),

vendor as (
  select *
  from {{ raw_db }}.{{ sc_u }}.pm00200
),

vendor_master as (
    select
        '{{ company_id }}' as company_id,
        trim(upper(vendorid)) as vendor_id,
        trim(upper(vendname)) as vendor_name,
        trim(upper(vndclsid)) as vendor_class,
        trim(upper(creatddt)) as created_date,
        trim(upper(userdef1)),
        trim(upper(pymtrmid)) as payment_terms_id,
        trim(upper(address1)) as address_1,
        trim(upper(address2)) as address_2,
        trim(upper(address3)) as address_3,
        trim(upper(city)),
        trim(upper(state)),
        trim(upper(zipcode)) as zip_code,
        trim(upper(country)),
        trim(upper(curncyid)) as currency_id,
        trim(upper(txidnmbr)) as tax_id,
        case
            when vendstts = 1 then 'Active'
            when vendstts = 2 then 'Inactive'
            when vendstts = 3 then 'Temporary'
        end as vendor_status,
        case
            when ten99type = 1 then 'Not a 1099 Vendor'
            when ten99type = 2 then 'Dividend'
            when ten99type = 3 then 'Interest'
            when ten99type = 4 then 'Miscellaneous'
        end as ten99_type,
        case 
            when userdef1 in ('RELATED PARTY', 'R/P', 'RELATEDPARTY') then 'Related Party'
            when userdef1 in ('IC', 'INTERCOMPANY', 'INTER COMPANY', 'I/C') then 'Inter Company'
            when userdef1 like '%DNB%' then 'SCF Vendor'
            else 'Trade'
        end as vendor_type,
        md5(concat(trim(upper(company_id)), trim(upper(vendor_id)))) as sk_vendor_global
    from
        vendor
)

select *
from vendor_master

{% endmacro %}
