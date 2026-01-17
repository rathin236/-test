{# in dbt Develop #}

{% set old_fct_orders_query %}
  select
    STATUS, 
	SOURCE,
	COMPANY, 
	PRODUCTID, 
	UNITGROUPNAME, 
	BASEUNITNAME, 
	DESCRIPTION, 
	UOMSCHEDULEID, 
	UOMID 
    
  from STAGING_DEV.D365_CE.V_PRODUCT_UNIT_GROUPS
{% endset %}

{% set new_fct_orders_query %}
  select
    status,
    source,
    company,
    productid,
    unitgroupname,
    baseunitname,
    description,
    uomscheduleid,
    uomid

  from {{ ref('d365_crm__v_product_unit_groups') }}
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="uomid",
    summarize= true
) }}

-- order by productid
