with
source as (
    select * from {{ source('bioln_dbo', 'ttdsta200600') }}
),

filtered as (
    select * from source
    where coalesce(_fivetran_deleted, false) = false
),

renamed as (
    select
        t_atvs,
        t_csor as "Sort",
        t_peri as "Period",
        t_yrno as "Year",
        t_sbqi as "Inventory Unit",
        t_sbqo as "Ordered Unit",
        t_sbqp as "Price Unit",
        t_sbam_1 as "Amount",
        t_sbcg_1 as cogs
    from filtered
)

select * from renamed
