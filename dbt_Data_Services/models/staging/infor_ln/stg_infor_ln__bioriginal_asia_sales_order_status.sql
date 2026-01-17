with

source as (

    select * from {{ source('bioln_dbo', 'ttdsls400600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_hdst as sales_order_status,
        t_orno as order_number,
        t_ccur as sales_currency,
        t_ddat as delivery_date

    from filtered

)

select * from renamed
