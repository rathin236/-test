with final as (
    select * from {{ ref('int_pronto_forms__timesheet') }}
)

select * from final