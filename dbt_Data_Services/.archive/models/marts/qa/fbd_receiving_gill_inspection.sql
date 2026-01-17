with final as (

    select * from {{ ref('int_qa__fbd_receiving_gill_inspection') }}
)

select * from final
