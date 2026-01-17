with userprofile as (
    select * from {{ ref('int_metaviewer_ap__user_profiles') }}
)

select * from userprofile
