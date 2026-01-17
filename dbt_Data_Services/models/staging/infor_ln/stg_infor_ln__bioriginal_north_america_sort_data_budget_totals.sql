with
source as (
    select * from {{ source('bioln_dbo', 'ttdsta203100') }}
),

filtered as (
    select * from source
    where coalesce(_fivetran_deleted, false) = false
),

renamed as (
    select
        t_atvs,
        t_csor as "Sort",
        t_yrno as "Year",
        100 as "Company"
    from filtered
)

select * from renamed
