with origin_output as (
    select
        curvename,
        dimension
    from {{ ref('int_kontali_taxonomyoutput') }}
    where category = 'Origin'
)

select * from origin_output
