with location_output as (
    select
        curvename,
        dimension
    from {{ ref('int_kontali_taxonomyoutput') }}
    where category = 'Location'
)

select * from location_output
