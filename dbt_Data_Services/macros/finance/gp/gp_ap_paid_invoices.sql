{# macros/gp_paid_ap.sql #}
{% macro render_gp_paid_ap_for(schema_code) %}

{% set raw_db = var('gp_raw_db', 'gp') %}

{% set sc_l = schema_code | lower %}
{% set sc_u = schema_code | upper %}

{% set company_id = sc_u | replace('_DBO', '') %}

with company as (
    select {{ trim_columns_int('stg_gp__company_name') }}
    from {{ ref('stg_gp__company_name') }}
    where trim(upper(interid)) = '{{ company_id }}'
),
funlcurr as (
    select trim(funlcurr) as funlcurr
    from {{ raw_db }}.{{ sc_u }}.mc40000
    where coalesce(lower(_fivetran_deleted), 'true') = 'false'
),

paid as (
    select *
    from {{ raw_db }}.{{ sc_u }}.pm30200
    where coalesce(voided, 0) = 0
      and coalesce(lower(_fivetran_deleted), 'true') = 'false'
      and cast(posteddt as date) > date('2022-12-31')
),
vendor_master as (
    select *
    from {{ raw_db }}.{{ sc_u }}.pm00200
    where coalesce(lower(_fivetran_deleted), 'true') = 'false'
),
receipts as (
    select *
    from {{ raw_db }}.{{ sc_u }}.mc020103
    where dcstatus = '3'
    and coalesce(lower(_fivetran_deleted), 'true') = 'false'
),
-- keep key_date visible so downstream joins compile
dim_rates as (
    select
        cast(key_date as date) as key_date,
        upper(trim(from_ccy))  as from_ccy,
        upper(trim(to_ccy))    as to_ccy,
        rate
    from {{ ref('dim__daily_exchange_rates') }}
    where key_date > date('2022-12-31')
),
dim_document_type as (
    select 
        doctype,
        document_type
    from {{ ref('int_global_ap__gp_document_type') }}
),
fact_paid_ap as (
    select
        /* ids / keys */
        cast(paid.dex_row_id as number) as transaction_id,
        '{{ company_id }}' as company_id,
        trim(upper(vend_mst.vendorid)) as vendor_id,
        cast(paid.doctype as number) as document_type_id,
        dty.document_type as document_type_desc,

        /* vendor attrs */
        trim(vend_mst.vndclsid) as vendor_class_id,
        trim(vend_mst.vendname) as vendor_name,

        /* doc attrs */
        trim(upper(paid.curncyid)) as currency_id,
        trim(upper(paid.vchrnmbr)) as voucher,
        trim(upper(paid.bachnumb)) as bach_number,
        trim(upper(paid.bchsourc)) as bach_source,
        trim(upper(paid.pymtrmid)) as payment_terms,
        -- trim(upper(paid.pymtrmid)) , --this column is the same as column above, but I have kept it for now as it was included in the original model
        trim(upper(paid.mdfusrid)) as userid,
        trim(upper(paid.docnumbr)) as document_number,
        trim(upper(paid.trxdscrn)) as description,
        trim(upper(paid.chekbkid)) as checkbook_id,

        /* dates */
        cast(paid.docdate  as date) as document_date,
        cast(paid.posteddt as date) as gl_posting_date,
        cast(paid.posteddt as date) as posting_date,
        cast(paid.duedate  as date) as due_date,
        cast(null as timestamp)                          as voided_date,
        paid.voided                                        as voided,

        /* misc */
        nullif(trim(paid.ponumber),  '') as pm_po_number,
        nullif(trim(paid.pordnmbr), '')  as pm_po_number_alt,
        trim(upper(paid.pordnmbr))                         as po_number,
        (select funlcurr from funlcurr)  as company_currency,

        /* postings metadata from MC020103 */
        receipts.xchgrate as exchange_rate,
        trim(upper(receipts.exgtblid)) as exchange_table_id,
        trim(upper(receipts.curncyid)) as originating_currency,
        trim(upper(receipts.ratetpid)) as rate_type_id,

        /* functional amounts (keep as-is) */
        case when paid.doctype < 4
             then cast(paid.docamnt  as number(38, 5))
             else cast(paid.docamnt  as number(38, 5)) * -1
        end as functional_document_amount,

        case when paid.doctype < 4
             then cast(paid.curtrxam as number(38, 5))
             else cast(paid.curtrxam as number(38, 5)) * -1
        end as functional_transaction_amount,

        /* originating amounts from MC020103 (keep as-is) */
        case when paid.doctype < 4
             then cast(receipts.ordocamt as number(38, 5))
             else cast(receipts.ordocamt as number(38, 5)) * -1
        end as originating_document_amount,

        case when paid.doctype < 4
             then cast(receipts.orchkttl as number(38, 5))
             else cast(receipts.orchkttl as number(38, 5)) * -1
        end as originating_check_total,

        case when paid.doctype < 4
             then cast(receipts.orappamt as number(38, 5))
             else cast(receipts.orappamt as number(38, 5)) * -1
        end as originating_applied_amount,

        /* converted originating amounts using posted-date functional rate */
        {{ ap_currency_conversion(
            'trim(upper(paid.doctype))',
            'trim(upper(paid.curncyid))',
            'paid.docamnt',
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }} as converted_originating_doc_amount,

        {{ ap_currency_conversion(
            'trim(upper(paid.doctype))',
            'trim(upper(paid.curncyid))',
            'paid.curtrxam',                     
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }} as converted_originating_trans_amount,

                /* CAD / USD (posted-date) */
        /* CAD / USD from originating currency */
        {{ forex_convert('currency_id', "'CAD'",
                        'converted_originating_trans_amount',
                        'coalesce(rate_cad.rate, 1)') }} as cad_amount,

        {{ forex_convert('currency_id', "'USD'",
                        'converted_originating_trans_amount',
                        'coalesce(rate_usd.rate, 100)') }} as usd_amount,
rate_usd.rate,
        {{ forex_convert('currency_id', "'CAD'",
                        'paid.prchamnt',
                        'coalesce(rate_cad.rate, 1)') }} as cad_purchase_amount,

        {{ forex_convert('currency_id', "'USD'",
                        'paid.prchamnt',
                        'coalesce(rate_usd.rate, 100)') }} as usd_purchase_amount,

        /* intervals */
        -datediff('day', cast(paid.posteddt as date), cast(paid.docdate as date)) as days_to_pay,
         datediff('day', cast(paid.posteddt as date), cast(paid.duedate as date)) as days_to_overdue,

        /* keys + status */
        md5(concat('{{ company_id }}', trim(upper(vend_mst.vendorid)))) as sk_vendor_global,
        md5(concat(cast(paid.doctype as varchar), 'GP'))          as sk_doctype_global,
        'PAID'                                                   as status,

        /* sync watermark */
        greatest(
            coalesce(paid._fivetran_synced,     to_timestamp('1900-01-01')),
            coalesce(receipts._fivetran_synced, to_timestamp('1900-01-01'))
        ) as _fivetran_synced

    from paid
    left join vendor_master as vend_mst
        on trim(upper(paid.vendorid)) = trim(upper(vend_mst.vendorid))
    left join receipts
        on upper(trim(paid.vchrnmbr)) = upper(trim(receipts.vchrnmbr))
       and upper(trim(paid.vendorid)) = upper(trim(receipts.vendorid))
       and trim(paid.doctype) = trim(receipts.doctype)

    /* conversion to functional (posted-date) */
    left join dim_rates as rate_func
        on rate_func.key_date = cast(paid.posteddt as date)
       and rate_func.from_ccy = upper(trim(currency_id))
       and rate_func.to_ccy   = upper(trim((select funlcurr from funlcurr)))

    /* per-row FX from originating → CAD / USD (by posted date) */
    left join dim_rates as rate_cad
        on rate_cad.key_date = cast(paid.posteddt as date)
        and rate_cad.from_ccy = upper(trim(currency_id))
        and rate_cad.to_ccy   = 'CAD'

    left join dim_rates as rate_usd
        on rate_usd.key_date = cast(paid.posteddt as date)
        and rate_usd.from_ccy = upper(trim(currency_id))
        and rate_usd.to_ccy   = 'USD'

    left join dim_document_type as dty
        on paid.doctype = dty.doctype
)

select *
from fact_paid_ap

{% endmacro %}
 