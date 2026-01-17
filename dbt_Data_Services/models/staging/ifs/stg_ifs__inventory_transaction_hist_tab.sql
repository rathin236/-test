with source as (

    select * from {{ source('ifs_prod_omeg1app', 'inventory_transaction_hist_tab') }}

),

renamed as (

    select
        transaction_id,
        delivery_overhead,
        owning_vendor_no,
        part_no,
        serial_no,
        eng_chg_level,
        quantity,
        date_time_created,
        pre_trans_level_qty_in_transit,
        modify_date_applied_user,
        alt_source_ref_type,
        alt_source_ref3,
        alt_source_ref4,
        alt_source_ref1,
        alt_source_ref2,
        date_applied,
        location_group,
        pallet_id,
        userid,
        transaction_code,
        original_transaction_id,
        accounting_id,
        sequence_no,
        rowkey,
        lot_batch_no,
        pre_accounting_id,
        pre_trans_level_qty_in_stock,
        expiration_date,
        location_no,
        source,
        valuestat_flag,
        catch_quantity,
        catch_direction,
        abnormal_demand,
        date_created,
        inventory_part_cost_level,
        qty_reversed,
        partstat_flag,
        activity_seq,
        condition_code,
        previous_owning_customer_no,
        contract,
        transit_location_group,
        order_no,
        inventory_valuation_method,
        configuration_id,
        owning_customer_no,
        rowversion,
        project_id,
        release_no,
        line_item_no,
        direction,
        order_type,
        modify_date_applied_date,
        previous_part_ownership,
        waiv_dev_rej_no,
        reject_code,
        previous_owning_vendor_no,
        transaction_report_id,
        part_ownership,
        receipt_date,
        report_earned_value,
        del_type,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
