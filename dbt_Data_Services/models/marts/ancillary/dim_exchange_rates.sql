with exchange_dimension as (
    select 
        * 
    from {{ ref('int_ancillary__daily_exchange_rates') }}
)

select * from exchange_dimension
