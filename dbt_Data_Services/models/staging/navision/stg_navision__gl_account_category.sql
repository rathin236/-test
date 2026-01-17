with source as (

    select * from {{ source('culmarex_dw_dbo', 'nav_onestream_g_l_account_category') }}

),

renamed as (

    select
        id,
        sibling_sequence_no_,
        additional_report_definition,
        id_company,
        system_generated,
        entry_no_,
        account_category,
        company,
        indentation,
        parent_entry_no_,
        description,
        income_balance,
        presentation_order,
        _fivetran_deleted,
        _fivetran_synced
    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
