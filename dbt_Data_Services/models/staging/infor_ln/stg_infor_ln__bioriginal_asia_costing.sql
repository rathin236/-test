with

source as (

    select * from {{ source('bioln_dbo', 'tticpr007600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_ecpr_1 as standard_cost,
        t_item as item_number

    from filtered
)

select * from renamed
