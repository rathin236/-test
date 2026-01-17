with source as (

    select * from {{ source('ifs_prod_omeg1app', 'purchase_part_tab') }}

),

renamed as (

    select
        contract,
        part_no,
        eng_attribute,
        inventory_flag,
        taxable,
        description,
        standard_pack_size,
        rowversion,
        process_type,
        note_text,
        over_delivery,
        stat_grp,
        close_tolerance,
        buyer_code,
        dop_pegged_po_update_flag,
        rowkey,
        close_code,
        text_id_,
        date_cre,
        qc_date,
        default_buy_unit_meas,
        over_delivery_tolerance,
        technical_coordinator_id,
        note_id,
        qc_code,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
