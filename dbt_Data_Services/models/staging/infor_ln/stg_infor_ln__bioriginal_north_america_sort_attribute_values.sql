with
source as (
    select * from {{ source('bioln_dbo', 'ttdsta202100') }}
),

filtered as (
    select * from source
    where coalesce(_fivetran_deleted, false) = false
),

renamed as (
    select
        t_attv,
        t_csor as "Sort",
        t_yrno as "Year",
        t_attr as "Attribute",
        t_attv as "Attribute Value"
    from filtered
)

select * from renamed
