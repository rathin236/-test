{# in dbt Develop #}

{% set old_fct_orders_query %}
  select
	STATUS,
	SOURCE,
	COMPANY,
	PRODUCTID,
	PRICELIST,
	PRICELISTID,
	UNIT,
	AMOUNT,
	CURRENCY,
	QUANTSELLOPT,
	ROUNDPOLICY,
	PRODUCTUID,
	UOMSCHEDULES as uomscheduleid
    
  from STAGING_DEV.D365_CE.V_PRODUCT_PRICE_LISTS
{% endset %}

{% set new_fct_orders_query %}
  select
    status,
    source,
    company,
    productid,
    pricelist,
    pricelistid,
    unit,
    amount,
    currency,
    quantsellopt,
    roundpolicy,
    productuid,
    uomscheduleid

  from {{ ref('d365_crm__v_product_price_lists') }}
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="productid",
    summarize=false

) }}
order by productid
