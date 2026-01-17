{# in dbt Develop #}

{% set old_fct_orders_query %}
  select
	STATUS,
	SOURCE,
	COMPANY,
	ACCOUNTNUM,
	NAME as custname,
	INVOICEACCOUNT,
	CUSTGROUP,
	INVOICINGANDDELIVERYONHOLD,
	ACCOUNTSTATUS,
	CURRENCY,
	EMPLOYEERESPONSIBLEID,
	EMPLOYEERESPONSIBLE,
	PAYTERMID,
	STREET,
	CITY,
	STATE,
	COUNTY,
	ZIPCODE,
	COUNTRY,
	OWNERTYPE,
	COMPANYUID,
	ACCOUNTUID,
	ACCOUNTSTATUSUID,
	CURRENCYUID,
	ERRORLOG,
    CREDMANSTATUSREASONID
    
  from STAGING_DEV.D365_CE.V_CUSTOMERS
  order by accountnum
{% endset %}

{% set new_fct_orders_query %}
  select
    status,
    source,
    company,
    accountnum,
    custname,
    invoiceaccount,
    custgroup,
    invoicinganddeliveryonhold,
    accountstatus,
    currency,
    employeeresponsibleid,
    employeeresponsible,
    paytermid,
    street,
    city,
    state,
    county,
    zipcode,
    country,
    ownertype,
    companyuid,
    accountuid,
    accountstatusuid,
    currencyuid,
    errorlog,
    credmanstatusreasonid

  from {{ ref('d365_crm__v_customers') }}
  order by accountnum
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="accountnum",
    summarize=true 

) }}
-- order by accountnum
