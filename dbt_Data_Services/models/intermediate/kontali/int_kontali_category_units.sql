with unit_output as (
    select
        curvename,
        dimension
    from {{ ref('int_kontali_taxonomyoutput') }}
    where category = 'Unit'
)

select * from unit_output
