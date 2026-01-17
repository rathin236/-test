with

source as (

    select * from {{ source('bioln_dbo', 'twhwmd251600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_alor as order_number,
        t_alln as line_number,
        t_alsq as sequence_number,
        t_cwar as warehouse_number,
        t_pyor as purchase_order_number,
        t_pyln as purchase_order_line,
        t_qiss as quantity

    from filtered
)

select * from renamed
