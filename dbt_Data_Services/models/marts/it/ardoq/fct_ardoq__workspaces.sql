with workspaces as (
    select *
    from {{ ref('int_ardoq_workspaces_flattened') }}
)

select * from workspaces
