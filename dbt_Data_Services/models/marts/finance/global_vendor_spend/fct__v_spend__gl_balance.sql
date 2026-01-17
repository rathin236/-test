with gp_vend_spend as (
    select
        *,
        md5(
            concat_ws('||',
                coalesce(company_id, ''),
                coalesce(sk_vendor_global, ''),
                coalesce(sk_gl_account_global, ''),
                coalesce(to_char(voucher), '')
            )
        ) as sk_v_spend_global
    from {{ ref('fct_gp__v_spend_gl_balance') }}
),

d365_vend_spend as (
    select
        *,
        md5(
            concat_ws('||',
                coalesce(company_id, ''),
                coalesce(sk_vendor_global, ''),
                coalesce(sk_gl_account_global, ''),
                coalesce(to_char(voucher), '')
            )
        ) as sk_v_spend_global
    from {{ ref('fct_d365__v_spend_gl_balance') }}
),

vendor_spend as (
    select * from gp_vend_spend

    union 

    select * from d365_vend_spend
)

select * from vendor_spend

