with grouped as (
    select * from {{ ref('int_metaviewer_ap__track_approvers') }}
)

select * from grouped
