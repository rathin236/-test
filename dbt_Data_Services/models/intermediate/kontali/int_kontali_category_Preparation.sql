with preparation_output as (
    select
        curvename,
        dimension
    from {{ ref('int_kontali_taxonomyoutput') }}
    where category = 'Preparation'
)

select * from preparation_output
