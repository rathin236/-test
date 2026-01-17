{# in dbt Develop #}

{% set old_fct_orders_query %}
  select
	STATUS,
	SOURCE,
	COMPANY,
	PRODUCTID,
	UNITGROUP,
	BASEUNIT,
	FROMUNIT,
	TOUNIT,
	CONVERSIONFACTOR,
	UOMSCHEDULEEDITLINK,
	DEFAULTUOMID
    
  from STAGING_DEV.D365_CE.V_PRODUCT_UNITS
{% endset %}

{% set new_fct_orders_query %}
  select
    status,
    source,
    company,
    productid,
    unitgroup,
    baseunit,
    fromunit,
    tounit,
    conversionfactor,
    uomscheduleeditlink,
    defaultuomid

  from {{ ref('d365_crm__v_product_units') }}
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="productid",
    summarize = false

) }}

-- where unitgroup ='12CASE454G'
-- where productid not in('', null)
order by productid

