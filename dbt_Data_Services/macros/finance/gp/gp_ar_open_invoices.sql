{# macros/gp_ar_open_invoices.sql #}
{% macro render_gp_open_ar_for(schema_code) %}

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
  open_documents as (
      -- RM20101: AR transaction work/open documents
      select *
      from {{ raw_db }}.{{ sc_u }}.rm20101
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
          cast(od.dex_row_id as number(38, 5))                       as transaction_id,
          '{{ sc_u }}'                                                as company_id,
          trim(upper(cm.custnmbr))                                    as customer_id,
          cast(od.rmdtypal as number(38, 5))                          as document_type_id,
          dty.document_type                                           as document_type_desc,

          /* company label + currency + customer extras */
          (select funlcurr from funlcurr)                             as company_currency,
          cm.custclas                                                 as customer_class_id,
          cm.custname                                                 as customer_name,
          cm.pymtrmid                                                 as payment_terms,
          clt.credit_limit_desc                                       as credit_limit_type,
          coalesce(cm.crlmtamt, 0)                                    as customer_credit_limit,

          /* currency + voucher/doc fields */
          case
              when od.curncyid like '%Z-EURO%' then 'EUR'
              else coalesce(od.curncyid, 'N/A')
          end                                                         as currency_id,
          -- AR has no voucher; keep null if you later need parity with AP
          -- cast(null as varchar)                                    as voucher,
          od.bachnumb                                                 as bach_number,
          od.bchsourc                                                 as bach_source,
          -- od.mdfusrid                                              as userid (not present in RM20101)
          upper(trim(od.docnumbr))                                    as document_number,

          /* dates */
          cast(od.docdate  as date)                                   as document_date,
          cast(od.glpostdt as date)                                   as gl_posting_date,
          -- cast(od.pstgdate as date)                                as posting_date (not in RM20101)
          cast(od.duedate  as date)                                   as due_date,
          cast(null as timestamp)                                     as voided_date,
          od.voidstts                                                 as voided,

          /* description */
          od.trxdscrn                                                 as description,

          /* exchange details from MC020102 (left join) */
          mcr.xchgrate                                                as exchange_rate,
          mcr.exgtblid                                                as exchange_table_id,
          mcr.curncyid                                                as originating_currency,
          mcr.ratetpid                                                as rate_type_id,

          /* AR amounts, sign-safe per RM type */
          iff(od.rmdtypal < 7, mcr.orslsamt, -mcr.orslsamt)           as originating_sales_amount,
          iff(od.rmdtypal < 7, mcr.orctrxam, -mcr.orctrxam)           as originating_transaction_amount,
          iff(od.rmdtypal < 7, mcr.ororgtrx, -mcr.ororgtrx)           as or_originating_transaction,

          iff(od.rmdtypal < 7, od.curtrxam, -od.curtrxam)             as functional_current_transaction_amount,
          iff(od.rmdtypal < 7, od.ortrxamt, -od.ortrxamt)             as functional_originating_transaction_amount,

          /* watermark across sources */
          greatest(
            coalesce(od._fivetran_synced,  to_timestamp('1900-01-01')),
            coalesce(mcr._fivetran_synced, to_timestamp('1900-01-01'))
          )                                                            as _fivetran_synced

      from open_documents od
      left join customer_master cm
        on trim(od.custnmbr) = trim(cm.custnmbr)

      /* bring in MC020102 for exchange/meta */
      left join mcr
        on trim(od.docnumbr) = trim(mcr.docnumbr)
       and trim(od.custnmbr) = trim(mcr.custnmbr)

      /* (optional) rate joins if you later enable conversion helpers
      left join dim_rates rate_func
        on cast(rate_func.key_date as date) = cast(od.docdate as date)
       and upper(trim(rate_func.from_ccy))  = upper(trim(od.curncyid))
       and upper(trim(rate_func.to_ccy))    = upper(trim((select funlcurr from funlcurr)))

      left join dim_rates today_cad
        on cast(today_cad.key_date as date) = cast(current_date() as date)
       and upper(trim(today_cad.from_ccy))  = upper(trim(od.curncyid))
       and upper(trim(today_cad.to_ccy))    = 'CAD'

      left join dim_rates today_usd
        on cast(today_usd.key_date as date) = cast(current_date() as date)
       and upper(trim(today_usd.from_ccy))  = upper(trim(od.curncyid))
       and upper(trim(today_usd.to_ccy))    = 'USD'
      */

      left join dim_document_type as dty
        on od.rmdtypal = dty.doctype

      left join dim_credit_limit_type as clt
        on cm.crlmttyp = clt.credit_limit_type
  )

  select *
  from fact_open_ap

{% endmacro %}
