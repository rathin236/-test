with cte as (
    select
        *
    from {{ ref('int_easyvista__contracts') }}
)
select * from cte
