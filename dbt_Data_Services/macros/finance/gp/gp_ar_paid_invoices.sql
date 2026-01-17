{# macros/gp_ar_paid_invoices.sql #}
{% macro render_gp_paid_ar_for(schema_code) %}

  {% set raw_db = var('gp_raw_db', 'gp') %}
  {% set sc_u = schema_code | upper %}
  {% set sc_l = schema_code | lower %}
  {% set company_id = sc_u | replace('_DBO', '') %}

  with company as (
      select {{ trim_columns_int('stg_gp__company_name') }}
      from {{ ref('stg_gp__company_name') }}
      where trim(upper(interid)) = '{{ company_id }}'
  ),
  funlcurr as (
      select trim(funlcurr) as funlcurr
      from {{ raw_db }}.{{ sc_u }}.mc40000
      qualify row_number() over (order by 1) = 1
  ),
  paid_documents as (
      -- RM30101: AR transaction history (paid/posted)
      select *
      from {{ raw_db }}.{{ sc_u }}.rm30101
      where coalesce(voidstts, 0) = 0
        and cast(docdate as date) > date '2020-12-31'
  ),
  customer_master as (
      -- RM00101: Customer master
      select *
      from {{ raw_db }}.{{ sc_u }}.rm00101
  ),
  mcr as (
      -- MC020102: AR currency details (originating amounts/exchange)
      select *
      from {{ raw_db }}.{{ sc_u }}.mc020102
  ),
  dim_rates as (
      select {{ trim_columns_int('dim__daily_exchange_rates') }}
      from {{ ref('dim__daily_exchange_rates') }}
      where key_date > date '2020-12-31'
  ),
  dim_document_type as (
      select 
          doctype,
          document_type
      from {{ ref('int_global_ar__gp_document_type') }}
  ),
dim_credit_limit_type as (
      select
          credit_limit_type,
          credit_limit_desc
      from {{ ref('int_global_ar__gp_customer_credit_limit_type') }}
),
fact_open_ap as (
      select
          /* existing keys */
          cast(pd.dex_row_id as number(38,5))              as transaction_id,
          '{{ company_id }}'                                as company_id,
          trim(upper(cm.custnmbr))                          as customer_id,
          cast(pd.rmdtypal as number(38,5))                 as document_type_id,
          dty.document_type                                 as document_type_desc,

          /* “company” label + currency + vendor extras (kept as in AR data) */
          (select funlcurr from funlcurr)                   as company_currency,
          cm.custclas                                       as customer_class_id,
          cm.custname                                       as customer_name,
          cm.pymtrmid                                       as payment_terms,
          clt.credit_limit_desc                             as credit_limit_type,
          coalesce(cm.crlmtamt, 0)                          as customer_credit_limit,

          /* currency + voucher/doc fields */
          case
              when pd.curncyid like '%Z-EURO%' then 'EUR'
              else coalesce(pd.curncyid, 'N/A')
          end                                               as currency_id,
          cast(null as varchar)                             as voucher,             -- AR has no voucher; keep null for parity
          pd.bachnumb                                       as bach_number,
          pd.bchsourc                                       as bach_source,
          upper(trim(pd.docnumbr))                          as document_number,

          /* dates */
          cast(pd.docdate  as date)                         as document_date,
          cast(pd.glpostdt as date)                         as gl_posting_date,
          cast(pd.glpostdt as date)                         as posting_date,
          cast(pd.duedate  as date)                         as due_date,
          cast(null as timestamp)                           as voided_date,
          pd.voidstts                                       as voided,

          /* descriptions / PO / misc (kept as in AR data) */
          pd.trxdscrn                                       as description,

          /* exchange details from MC020102 (left join) */
          mcr.xchgrate                                      as exchange_rate,
          mcr.exgtblid                                      as exchange_table_id,
          mcr.curncyid                                      as originating_currency,
          mcr.ratetpid                                      as rate_type_id,

          /* AR amounts, sign-safe per RM type (kept as in AR data) */
          iff(pd.rmdtypal < 7, mcr.orslsamt, -mcr.orslsamt)   as originating_sales_amount,
          iff(pd.rmdtypal < 7, mcr.orctrxam, -mcr.orctrxam)   as originating_transaction_amount,
          iff(pd.rmdtypal < 7, mcr.ororgtrx, -mcr.ororgtrx)   as or_originating_transaction,

          iff(pd.rmdtypal < 7, pd.curtrxam, -pd.curtrxam)     as functional_current_transaction_amount,
          iff(pd.rmdtypal < 7, pd.ortrxamt, -pd.ortrxamt)     as functional_originating_transaction_amount,

          /* NEW: watermark across sources */
          greatest(
            coalesce(pd._fivetran_synced,  to_timestamp('1900-01-01')),
            coalesce(mcr._fivetran_synced, to_timestamp('1900-01-01'))
          )                                                  as _fivetran_synced

      from paid_documents pd
      left join customer_master cm
        on upper(trim(pd.custnmbr)) = upper(trim(cm.custnmbr))

      /* bring in MC020102 for exchange/meta */
      left join mcr
        on trim(upper(pd.docnumbr)) = trim(upper(mcr.docnumbr))
       and trim(upper(pd.custnmbr)) = trim(upper(mcr.custnmbr))

      /* (optional) fx helpers/joins were omitted here to match your AR columns exactly */
      left join dim_document_type as dty
        on pd.rmdtypal = dty.doctype

    left join dim_credit_limit_type as clt
        on cm.crlmttyp = clt.credit_limit_type       
  )

  select *
  from fact_open_ap

{% endmacro %}
