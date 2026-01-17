with source as (

    select * from {{ source('hsi_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_1,
        actnumbr_9,
        actnumbr_3,
        actnumbr_6,
        actnumbr_10,
        actnumbr_8,
        actnumbr_2,
        actnumst,
        actnumbr_5,
        actnumbr_4,
        dex_row_id,
        actnumbr_7,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
