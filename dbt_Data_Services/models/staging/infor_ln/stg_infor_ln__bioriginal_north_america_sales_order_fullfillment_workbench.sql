with

source as (

    select * from {{ source('bioln_dbo', 'ttdsls401100') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_orno as order_number,
        t_pono as line_number,
        t_sqnb as sequence_number,
        t_item as item_number,
        t_pric as price_sales_currency,
        t_ccty as home_currency,
        t_qoor as quantity,
        t_cuqs as sales_unit,
        t_oamt as total_amount_sales_currency,
        t_stbp as customer_bp_id,
        t_dldt as invoice_date,
        t_cono as contract_number,
        t_rats_1 as fx_rate_to_home_curr,
        t_clyn as canceled_order

    from filtered
)

select * from renamed
