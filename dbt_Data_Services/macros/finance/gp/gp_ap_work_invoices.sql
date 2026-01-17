{% macro render_gp_work_ap_for(schema_code) %}

 {% set raw_db = var('gp_raw_db', 'gp') %}

{% set sc_l = schema_code | lower %}
{% set sc_u = schema_code | upper %}

with funlcurr as (
    select trim(funlcurr) as funlcurr
    from {{ raw_db }}.{{ sc_u }}.mc40000
    qualify row_number() over (order by 1) = 1
),

work_payments as (
    select
        cast(dex_row_id as number)       as dex_row_id,
        trim(upper(vendorid))            as vendorid,
        cast(doctype as number)          as doctype,
        trim(upper(curncyid))            as curncyid,
        trim(upper(vchrnmbr))            as vchrnmbr,
        trim(upper(bachnumb))            as bachnumb,
        trim(upper(pymtrmid))            as pymtrmid,
        trim(upper(mdfusrid))            as mdfusrid,
        trim(upper(docnumbr))            as docnumbr,
        trim(upper(pordnmbr))            as po_number,
        cast(docdate as date)            as docdate,
        cast(posteddt as date)           as posteddt,
        cast(duedate as date)            as due_date,
        cast(docamnt as number(38, 5))   as docamnt,   -- functional in GP
        cast(curtrxam as number(38, 5))  as curtrxam,   -- originating in GP
        cast(prchamnt as number(38,5))   as prchamnt
    from {{ raw_db }}.{{ sc_u }}.pm10000
),
vendor_master as (
    select *
    from {{ raw_db }}.{{ sc_u }}.pm00200
),
dim_rates as (
    select *
    from {{ ref('dim__daily_exchange_rates') }}
),
fact_work_ap as (
    select
        wp.dex_row_id                                    as transaction_id,
        upper(replace('{{ sc_u }}', '_DBO', ''))         as company_id,
        trim(upper(vm.vendorid))                         as vendor_id,
        wp.doctype                                       as document_type_id,
        wp.curncyid                                      as currency_id,
        wp.vchrnmbr                                      as voucher,
        wp.bachnumb                                      as bach_number,
        wp.pymtrmid                                      as pymtrmid,
        wp.mdfusrid                                      as userid,
        wp.docnumbr                                      as document_number,
        wp.docdate                                       as document_date,
        wp.posteddt                                      as gl_posting_date,
        wp.due_date                                      as due_date,
        wp.po_number                                     as po_number,
        (select f.funlcurr from funlcurr f)              as company_currency,

        /* keep your existing columns as-is */
        case when wp.doctype < 4 then wp.docamnt else -wp.docamnt end  as functional_document_amount,
        case when wp.doctype < 4 then wp.curtrxam else -wp.curtrxam end as functional_transaction_amount,

        {{ ap_currency_conversion(
            'wp.doctype',
            'wp.curncyid',
            'wp.docamnt',
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }}  as originating_document_amount,
        {{ ap_currency_conversion(
            'wp.doctype',
            'wp.curncyid',
            'wp.curtrxam',
            'rate_func.rate',
            '(select funlcurr from funlcurr)'
        ) }}  as originating_transaction_amount,

        {{ forex_convert('wp.curncyid', "'CAD'", 'originating_transaction_amount', 'today_cad.rate') }} as cad_amount,
        {{ forex_convert('wp.curncyid', "'USD'", 'originating_transaction_amount', 'today_usd.rate') }} as usd_amount,

        {{ forex_convert('wp.curncyid', "'CAD'", 'prchamnt', 'today_cad.rate') }} as cad_purchase_amount,
        {{ forex_convert('wp.curncyid', "'USD'", 'prchamnt', 'today_usd.rate') }} as usd_purchase_amount,

        {{ aging_buckets('due_date', 'document_date', 'cad_amount') }},
        {{ aging_originating_buckets('due_date', 'document_date', 'usd_amount') }},

        md5(concat(company_id, trim(upper(vm.vendorid))))  as sk_vendor_global,
        md5(concat(cast(wp.doctype as varchar), 'GP'))       as sk_doctype_global,
        'WORK'                                               as status

    from work_payments wp
    left join vendor_master vm
        on upper(trim(wp.vendorid)) = upper(trim(vm.vendorid))

    /* doc-date rate: normalized date + ccy comparisons */
    left join dim_rates rate_func
        on cast(rate_func.key_date as date) = cast(wp.docdate as date)
       and upper(trim(rate_func.from_ccy)) = upper(trim(wp.curncyid))
       and upper(trim(rate_func.to_ccy))   = upper(trim((select funlcurr from funlcurr)))

    /* today’s cad/usd: normalized date + ccy comparisons */
    left join dim_rates today_cad
        on cast(today_cad.key_date as date) = cast(current_date() as date)
       and upper(trim(today_cad.from_ccy))  = upper(trim(wp.curncyid))
       and upper(trim(today_cad.to_ccy))    = 'CAD'

    left join dim_rates today_usd
        on cast(today_usd.key_date as date) = cast(current_date() as date)
       and upper(trim(today_usd.from_ccy))  = upper(trim(wp.curncyid))
       and upper(trim(today_usd.to_ccy))    = 'USD'
)

select *
from fact_work_ap

{% endmacro %}
