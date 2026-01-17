with workspaces as (
    select 
        *
    from {{ ref('int_powerbi__workspaces') }}
)
select * from workspaces
