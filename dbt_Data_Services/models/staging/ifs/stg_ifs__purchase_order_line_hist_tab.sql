with source as (

    select * from {{ source('ifs_prod_omeg1app', 'purchase_order_line_hist_tab') }}

),

renamed as (

    select
        history_no,
        revision,
        date_entered,
        release_no,
        rowversion,
        userid,
        order_no,
        hist_objstate,
        rowkey,
        line_no,
        message_text,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
