with source as (

    select * from {{ source('culmarex_dw_dbo', 'nav_onestream_accountschedule') }}

),

renamed as (

    select
        id,
        line_no_,
        value,
        totaling_type,
        schedule_name,
        amount_type,
        description,
        cost_object_totaling,
        row_type,
        show_opposite_sign,
        show,
        indentation,
        analysis_view_name,
        positive_only,
        cost_center_totaling,
        name,
        type,
        company,
        totaling,
        reverse_sign,
        row_description,
        row_no_,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
