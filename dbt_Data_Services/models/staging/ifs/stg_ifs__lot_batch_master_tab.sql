with source as (

    select * from {{ source('ifs_prod_omeg1app', 'lot_batch_master_tab') }}

),

renamed as (

    select
        lot_batch_no,
        part_no,
        shipped_qty,
        last_sales_date,
        scrapped_qty,
        manufactured_date,
        condition_code,
        order_type,
        rowkey,
        best_before_date,
        order_ref1,
        order_ref3,
        text_id_,
        order_ref2,
        create_date,
        order_ref4,
        expiration_date,
        received_qty,
        parent_part_no,
        potency,
        rowversion,
        note_text,
        parent_lot,
        initial_contract,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
