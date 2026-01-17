with mortality_causes as (
    select * from {{ ref('stg_fishtalk__mortality_causes') }}
),

ext_mortality_causes_v2 as (
    select

        mortalitycausesid as mortalitycauseid,
        {{ fishtalk_get_text('textid', 'defaulttext', 1) }} as name_,
        mortalitycausegroupid,
        textid

    from mortality_causes

    order by mortalitycauseid
)

select * from ext_mortality_causes_v2
