with final as (

    select * from {{ ref('int_qa__bh_condition_factor') }}
)

select * from final
