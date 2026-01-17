with fact as (
    select * from {{ ref('int_intelex__final_incidents') }}
)

select * from fact
