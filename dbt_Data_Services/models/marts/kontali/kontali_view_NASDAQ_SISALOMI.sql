with final as (
    select * from
    {{ ref('int_kontali_LatestCurves') }}
)
select * from final
