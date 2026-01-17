with

source as (

    select * from {{ source('bioln_dbo', 'ttdpur401200') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_orno as purchase_order_number,
        t_pono as purchase_order_line,
        t_qoor as quantity,
        t_pric as price,
        t_disc_1 as discount

    from filtered
)

select * from renamed
