with company as (
    select {{ trim_columns_int('stg_gp__company_name') }} from {{ ref('stg_gp__company_name') }}
)

select * from company
