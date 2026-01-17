with main_accounts as (
    select * from {{ ref('int_d365__dim_main_accounts') }}
),

gl_accounts as (
    select 
        main_account_id as gl_account_id,
        main_account_id as gl_account_number,
        main_account_id as act_num,
        upper(account_name) as gl_account_description,
        chart_of_accounts as company_id,
        md5(concat(trim(upper(chart_of_accounts)), trim(main_account_id))) as sk_gl_account_global
    from main_accounts
)

select * from gl_accounts
