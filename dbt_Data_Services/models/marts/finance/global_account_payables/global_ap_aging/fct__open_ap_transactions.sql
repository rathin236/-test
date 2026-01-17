with todays_rate as (
    select rate as exch_rate_today
    from {{ ref('dim_exchange_rates') }}
    where from_ccy = 'USD' and to_ccy = 'CAD' and fx_date = current_date()
),

gp_trans as (
    select
        *,
        'GP_TRANS' as source_type
    from {{ ref('fct_gp__open_transactions') }}
),

gp_work as (
    select
        *,
        'GP_WORK' as source_type
    from {{ ref('fct_gp__work_transactions') }}
    where vendor_id is not null
),

d365_trans as (
    select
        *,
        'D365_TRANS' as source_type
    from {{ ref('fct_d365__open_transactions') }}
),

all_sources as (
    select * from gp_trans
    union all
    select * from gp_work
    union all
    select * from d365_trans
),

with_exchange_and_key as (
    select
        all_sources.*,
        todays_rate.exch_rate_today,
        md5(
            concat_ws(
                '||',
                coalesce(all_sources.sk_vendor_global::string, ''),
                coalesce(all_sources.transaction_id::string, ''),
                coalesce(all_sources.document_type_id::string, ''),
                coalesce(all_sources.voucher::string, ''),
                coalesce(all_sources.document_number::string, ''),
                coalesce(all_sources.document_date::string, '')
            )
        ) as sk_ap_global
    from all_sources
    cross join todays_rate
),

deduped as (
    select wek.*
    from with_exchange_and_key as wek
    qualify row_number() over (
            partition by wek.sk_ap_global
            order by wek.document_date desc
        ) = 1
)

select * from deduped
