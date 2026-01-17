with

source as (

    select * from {{ source('monday', 'column_value') }}

),

renamed as (

    select
        board_id,
        item_id,
        id,
        value,
        text,
        title,
        type,
        _fivetran_deleted,
        _fivetran_synced,
        display_value,
        date,
        symbol,
        rating,
        description,
        settings_str,
        running,
        duration,
        archived,
        number,
        to_date,
        updated_at,
        label_style_color,
        direction,
        is_done,
        from_date,
        index,
        label,
        label_style_border,
        width,
        started_at,
        time,
        update_id,
        visualization_type,
        checked,
        icon

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
