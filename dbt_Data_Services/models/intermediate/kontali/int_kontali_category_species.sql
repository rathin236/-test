with species_output as (
    select
        curvename,
        dimension
    from {{ ref('int_kontali_taxonomyoutput') }}
    where category = 'Species'
)

select * from species_output
