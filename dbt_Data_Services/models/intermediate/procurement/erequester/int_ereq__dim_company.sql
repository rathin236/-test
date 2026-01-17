with company as (
    select * from {{ ref("stg_erequester__company") }}
)

select * from company
