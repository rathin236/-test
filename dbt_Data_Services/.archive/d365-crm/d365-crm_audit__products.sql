{# in dbt Develop #}

{% set old_fct_orders_query %}
  select
    PRODUCTID as productid,
    STATUS,
	SOURCE,
	COMPANY,
	PRODUCTSTRUCTURE,
	PRODUCTTYPE,
	PRODUCTDESC,
	UNITGROUP,
	UNIT,
	GPPRODUCTID,
	D365PRODUCTID,
	CRMPPRODUCTID as crmproductid,
	UOMSCHEDULEID,
	UOMID,
	COMPANYID,
	STATUSUID
    
    
  from STAGING_DEV.D365_CE.V_PRODUCTS
{% endset %}

{% set new_fct_orders_query %}
  select
    productid,
    status,
    source,
    company,
    productstructure,
    producttype,
    productdesc,
    unitgroup,
    unit,
    gpproductid,
    d365productid,
    crmproductid,
    uomscheduleid,
    uomid,
    companyid,
    statusuid
    

  from {{ ref('d365_crm_v_products') }}
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="productid" ,
    summarize = true
) }}
-- order by productid 
