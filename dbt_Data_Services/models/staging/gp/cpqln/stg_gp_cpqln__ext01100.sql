with source as (

    select * from {{ source('cpqln_dbo', 'ext01100') }}

),

renamed as (

    select
        extender_record_id,
        extender_key_values_4,
        modifdt,
        extender_key_values_1,
        mdfusrid,
        crusrid,
        extender_window_id,
        noteindx,
        extender_key_values_5,
        extender_key_values_2,
        dex_row_id,
        extender_key_values_3,
        creatddt,
        _fivetran_deleted,
        _fivetran_synced
    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
