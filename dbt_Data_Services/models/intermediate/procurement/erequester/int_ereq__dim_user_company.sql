with user_company as (
    select *
    from {{ ref('stg_erequester__user_company') }}
)

select * from user_company
