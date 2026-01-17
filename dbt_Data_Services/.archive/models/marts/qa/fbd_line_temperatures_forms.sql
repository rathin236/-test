with final as (

    select * from {{ ref('int_qa__fbd_line_temperatures') }}
)

select * from final
