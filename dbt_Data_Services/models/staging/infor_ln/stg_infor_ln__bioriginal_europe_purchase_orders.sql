with

source as (

    select * from {{ source('bioln_dbo', 'ttdpur400200') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_oamt as purchase_order_amount,
        t_ccur as purchase_order_currency,
        t_orno as purchase_order_number

    from filtered
)

select * from renamed
