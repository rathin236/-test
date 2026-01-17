with main as (
    select * from {{ ref('int_pronto__health_and_safety__field_level_hazard_assessment') }}
)

select * from main
