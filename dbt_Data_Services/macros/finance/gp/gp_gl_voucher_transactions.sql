{# macros/gp_gl_data.sql #}
{% macro render_gp_gl_data_for(schema_code) %}
  {% set raw_db = var('gp_raw_db', 'gp') %}
  {% set sc_u = schema_code | upper %}
{% set company_id = sc_u | replace('_DBO', '') %}

  with company as (
      select
          upper(trim(interid)) as interid
      from {{ ref('stg_gp__company_name') }}
      where trim(upper(interid)) = '{{ company_id }}'
  ),

  funlcurr as (
      select trim(upper(funlcurr)) as funlcurr
      from {{ raw_db }}.{{ sc_u }}.mc40000
      qualify row_number() over (order by 1) = 1
  ),

  open_gl as (
      select *
      from {{ raw_db }}.{{ sc_u }}.gl20000
      where series = '4'
        and year(orpstddt) > year(current_date) - 2
  ),

  hist_gl as (
      select *
      from {{ raw_db }}.{{ sc_u }}.gl30000
      where series = '4'
        and year(orpstddt) > year(current_date) - 2
  ),

  all_invoices as (
      select *
      from {{ ref('fct__ap_aging__all_invoices') }}
      where company_id = '{{ company_id }}'
  ),

  vendor_master as (
      select *
      from {{ raw_db }}.{{ sc_u }}.pm00200
  ),

  pop_trans as (
      select *
      from {{ raw_db }}.{{ sc_u }}.pop30300
  ),

  dim_rates as (
      select *
      from {{ ref('dim__daily_exchange_rates') }}
  ),

  rate_cad as (
      select *
      from dim_rates
      where upper(trim(to_ccy)) = 'CAD'
  ),

  rate_usd as (
      select *
      from dim_rates
      where upper(trim(to_ccy)) = 'USD'
  ),

  all_gljs as (
      select
          cast(openyear  as number)       as openyear,
          cast(trxdate   as date)         as trxdate,
          cast(actindx   as number)       as actindx,
          trim(upper(orgntsrc))           as orgntsrc,
          trim(upper(series))             as series,
          cast(ortrxtyp  as number)       as ortrxtyp,
          trim(upper(orctrnum))           as orctrnum,
          trim(upper(ormstrid))           as ormstrid,
          trim(upper(ordocnum))           as ordocnum,
          cast(orpstddt  as date)         as orpstddt,
          trim(upper(ortrxsrc))           as ortrxsrc,
          trim(upper(curncyid))           as curncyid,
          cast(periodid  as number)       as periodid,
          cast(debitamt  as number(38,5)) as debitamt,
          cast(crdtamnt  as number(38,5)) as crdtamnt,
          cast(ordbtamt  as number(38,5)) as ordbtamt,
          cast(orcrdamt  as number(38,5)) as orcrdamt
      from open_gl

      union all

      select
          cast(hstyear  as number)        as openyear,
          cast(trxdate  as date)          as trxdate,
          cast(actindx  as number)        as actindx,
          trim(upper(orgntsrc))           as orgntsrc,
          trim(upper(series))             as series,
          cast(ortrxtyp as number)        as ortrxtyp,
          trim(upper(orctrnum))           as orctrnum,
          trim(upper(ormstrid))           as ormstrid,
          trim(upper(ordocnum))           as ordocnum,
          cast(orpstddt as date)          as orpstddt,
          trim(upper(ortrxsrc))           as ortrxsrc,
          trim(upper(curncyid))           as curncyid,
          cast(periodid as number)        as periodid,
          cast(debitamt as number(38,5))  as debitamt,
          cast(crdtamnt as number(38,5))  as crdtamnt,
          cast(ordbtamt as number(38,5))  as ordbtamt,
          cast(orcrdamt as number(38,5))  as orcrdamt
      from hist_gl
  ),

  gl_data as (
      select
          '{{ company_id }}'                                                  as company_id,
          trim(upper(vm.vendorid))                                            as vendor_id,
          cast(gj.ortrxtyp as number)                                         as document_type_id,
          cast(gj.actindx as number)                                          as gl_account_id,
          (select f.funlcurr from funlcurr f)                                 as company_currency,
          trim(gj.orctrnum)                                                   as voucher,
          trim(gj.ordocnum)                                                   as document_number,
          cast(coalesce(ai.document_date, pop.receiptdate) as date)           as document_date,
          cast(gj.trxdate as date)                                            as gl_posting_date,
          cast(ai.due_date as date)                                           as due_date,
          cast(gj.orpstddt as date)                                           as gl_posted_date,
          ai.po_number                                                        as po_number,
          trim(gj.curncyid)                                                   as trans_currency,

          coalesce(gj.ordbtamt, 0) - coalesce(gj.orcrdamt, 0)                 as originating_amount,

          {{ forex_convert('gj.curncyid', "'CAD'", 'originating_amount', 'rate_cad.rate') }} as cad_amount,
          {{ forex_convert('gj.curncyid', "'USD'", 'originating_amount', 'rate_usd.rate') }} as usd_amount,

          md5(concat('{{ company_id }}', trim(upper(vm.vendorid))))           as sk_vendor_global,
          md5(concat(cast(gj.ortrxtyp as varchar), 'GP'))                     as sk_doctype_global,
          md5(concat('{{ company_id }}', trim(cast(gj.actindx as varchar))))  as sk_gl_account_global
      from all_gljs gj
      left join all_invoices ai
        on upper(trim(gj.orctrnum)) = upper(trim(ai.voucher))
       and upper(trim(gj.ormstrid)) = upper(trim(ai.vendor_id))
       and gj.ortrxtyp = ai.document_type_id
      left join vendor_master vm
        on upper(trim(gj.ormstrid)) = upper(trim(vm.vendorid))
      left join pop_trans pop
        on upper(trim(gj.orctrnum)) = upper(trim(pop.poprctnm))
       and upper(trim(gj.ormstrid)) = upper(trim(pop.vendorid))

      left join rate_cad
        on cast(gj.orpstddt as date) = rate_cad.key_date
       and upper(trim(rate_cad.from_ccy)) = upper(trim(gj.curncyid))

      left join rate_usd
        on cast(gj.orpstddt as date) = rate_usd.key_date
       and upper(trim(rate_usd.from_ccy)) = upper(trim(gj.curncyid))
  )

  select *
  from gl_data
{% endmacro %}
