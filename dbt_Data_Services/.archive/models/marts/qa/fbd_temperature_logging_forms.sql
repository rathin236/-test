with final as (

    select * from {{ ref('int_qa__fbd_temperature_logging_info') }}
)

select * from final
