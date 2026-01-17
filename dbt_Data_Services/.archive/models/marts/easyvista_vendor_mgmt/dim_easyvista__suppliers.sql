with cte as (
    select
        *
    from {{ ref('int_easyvista__suppliers') }}
)
select * from cte
