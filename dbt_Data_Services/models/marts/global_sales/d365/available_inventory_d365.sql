with invent_sum as (
    select * from {{ ref('stg_d365__invent_sum') }}
),

final as (
    select * from invent_sum
)

select * from final
