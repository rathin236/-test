with portfolio as (
    select *
    from {{ ref('int_ppm__portfolio_unpacking') }}
)

select * from portfolio
