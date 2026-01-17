{# macros/gp_open_ap.sql #}
{% macro render_gp_open_ap_for(schema_code) %}

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
open_payments as (
    select *
    from {{ raw_db }}.{{ sc_u }}.pm20000
    where coalesce(voided, 0) = 0
      and docdate > '2022-12-31'
),
vendor_master as (
    select *
    from {{ raw_db }}.{{ sc_u }}.pm00200
),
mcp as (
    -- exchange details / originating amounts by voucher+vendor
    select *
    from {{ raw_db }}.{{ sc_u }}.mc020103
),
dim_rates as (
    select {{ trim_columns_int('dim__daily_exchange_rates') }}
    from {{ ref('dim__daily_exchange_rates') }}
    where key_date > '2022-12-31'
),
dim_document_type as (
    select 
        doctype,
        document_type
    from {{ ref('int_global_ap__gp_document_type') }}
),
fact_open_ap as (
    select
        /* existing keys */
        cast(op.dex_row_id as number(38,5))              as transaction_id,
        '{{ company_id }}'                                     as company_id,
        trim(upper(vm.vendorid))                         as vendor_id,
        cast(op.doctype as number(38,5))                 as document_type_id,
        dty.document_type as document_type_desc,

        /* NEW: “company” label + currency + vendor extras */
        (select funlcurr from funlcurr)                  as company_currency,
        vm.vndclsid                                      as vendor_class_id,
        vm.vendname                                      as vendor_name,
        vm.pymtrmid                                      as payment_terms,

        /* currency + voucher/doc fields */
        case
            when op.curncyid like '%Z-EURO%' then 'EUR'
            else coalesce(op.curncyid, 'N/A')
        end                                              as currency_id,
        trim(upper(op.vchrnmbr))                         as voucher,
        trim(upper(op.bachnumb))                         as bach_number,
        trim(upper(op.bchsourc))                         as bach_source,
        trim(upper(op.mdfusrid))                         as userid,
        upper(trim(op.docnumbr))                         as document_number,

        /* dates */
        cast(op.docdate as date)                         as document_date,
        cast(op.posteddt as date)                        as gl_posting_date,
        cast(op.pstgdate as date)                        as posting_date,
        cast(op.duedate as date)                         as due_date,
        cast(null as timestamp)                          as voided_date,
        op.voided                                        as voided,

        /* descriptions / PO / misc */
        trim(op.trxdscrn)                                      as description,
        trim(upper(op.chekbkid))                                      as checkbook_id,
        nullif(trim(op.ponumber), '')                    as pm_po_number,
        nullif(trim(op.pordnmbr), '')                    as pm_po_number_alt,
        trim(upper(op.pordnmbr))                         as po_number,

        /* NEW: exchange details from MC020103 (left join) */
        mcp.xchgrate                                     as exchange_rate,
        trim(upper(mcp.exgtblid))                                     as exchange_table_id,
        trim(upper(mcp.curncyid))                                     as originating_currency,
        trim(upper(mcp.ratetpid))                                     as rate_type_id,

        /* functional (signed) — keep your original logic */
        case when op.doctype < 4 then op.docamnt else -op.docamnt end   as functional_document_amount,
        case when op.doctype < 4 then op.curtrxam else -op.curtrxam end as functional_transaction_amount,

        /* originating amounts from MC020103 (keep as-is) */
        case when op.doctype < 4
             then cast(mcp.ordocamt as number(38, 5))
             else cast(mcp.ordocamt as number(38, 5)) * -1
        end as originating_document_amount,

        case when op.doctype < 4
             then cast(mcp.orchkttl as number(38, 5))
             else cast(mcp.orchkttl as number(38, 5)) * -1
        end as originating_check_total,

        case when op.doctype < 4
             then cast(mcp.orappamt as number(38, 5))
             else cast(mcp.orappamt as number(38, 5)) * -1
        end as originating_applied_amount,        

        /* originating_* via helper (doc-date rate → functional ccy) */
        {{ ap_currency_conversion(
            'op.doctype',
            'op.curncyid',
            'op.docamnt',
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }}                                              as converted_originating_document_amount,
        {{ ap_currency_conversion(
            'op.doctype',
            'op.curncyid',
            'op.curtrxam',
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }}                                              as converted_originating_transaction_amount,

        /* today's cad/usd */
        {{ forex_convert('currency_id', "'CAD'", 'converted_originating_transaction_amount', 'today_cad.rate') }} as cad_amount,
        {{ forex_convert('currency_id', "'USD'", 'converted_originating_transaction_amount', 'today_usd.rate') }} as usd_amount,

        /* purchase amounts with today's CAD/USD */
        {{ forex_convert('currency_id', "'CAD'", 'prchamnt', 'today_cad.rate') }} as cad_purchase_amount,
        {{ forex_convert('currency_id', "'USD'", 'prchamnt', 'today_usd.rate') }} as usd_purchase_amount,

        /* aging + status */
        {{ aging_buckets('due_date', 'document_date', 'cad_amount') }},
        {{ aging_originating_buckets('due_date', 'document_date', 'usd_amount') }},
        md5(concat('{{ company_id }}', trim(upper(vm.vendorid))))             as sk_vendor_global,
        md5(concat(cast(op.doctype as varchar), 'GP'))                  as sk_doctype_global,
        'OPEN'                                                          as status,

        /* NEW: watermark across sources */
        greatest(
          coalesce(op._fivetran_synced,  to_timestamp('1900-01-01')),
          coalesce(mcp._fivetran_synced, to_timestamp('1900-01-01'))
        )                                                               as _fivetran_synced

    from open_payments op
    left join vendor_master vm
      on upper(trim(op.vendorid)) = upper(trim(vm.vendorid))

    /* bring in MC020103 for exchange/meta */
    left join mcp
      on upper(trim(op.vchrnmbr)) = upper(trim(mcp.vchrnmbr))
     and upper(trim(op.vendorid)) = upper(trim(mcp.vendorid))

    /* doc-date rate: normalized dates & currency codes */
    left join dim_rates rate_func
        on cast(rate_func.key_date as date) = cast(op.docdate as date)
       and upper(trim(rate_func.from_ccy))  = upper(trim(currency_id))
       and upper(trim(rate_func.to_ccy))    = upper(trim((select funlcurr from funlcurr)))

    /* today's cad/usd: normalized date & currency codes */
    left join dim_rates today_cad
        on cast(today_cad.key_date as date) = cast(current_date() as date)
       and upper(trim(today_cad.from_ccy))  = upper(trim(currency_id))
       and upper(trim(today_cad.to_ccy))    = 'CAD'
    left join dim_rates today_usd
        on cast(today_usd.key_date as date) = cast(current_date() as date)
       and upper(trim(today_usd.from_ccy))  = upper(trim(currency_id))
       and upper(trim(today_usd.to_ccy))    = 'USD'

    left join dim_document_type as dty
        on op.doctype = dty.doctype       
)

select *
from fact_open_ap

{% endmacro %}
 