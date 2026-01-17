with stand as (
    select * from {{ ref('stg_fishtalk__stand') }}
),

ext_stands_v2 as (
    select

        standid,
        orgunitid,
        name as standname,
        groupid

    from stand
)

select * from ext_stands_v2
