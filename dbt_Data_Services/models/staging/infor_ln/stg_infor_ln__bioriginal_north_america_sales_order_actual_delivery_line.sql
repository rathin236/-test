with

source as (

    select * from {{ source('bioln_dbo', 'ttdsls409100') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_cogs_1 as cogs_home_currency,
        t_orno as order_number,
        t_pono as line_number,
        t_sqnb as sequence_number

    from filtered
)

select * from renamed
