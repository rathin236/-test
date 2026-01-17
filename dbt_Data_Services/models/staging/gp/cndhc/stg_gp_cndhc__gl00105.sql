with source as (

    select * from {{ source('cndhc_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_5,
        actnumbr_8,
        actnumst,
        actnumbr_2,
        dex_row_id,
        actnumbr_3,
        actnumbr_10,
        actnumbr_1,
        actnumbr_6,
        actnumbr_9,
        actnumbr_4,
        actnumbr_7,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
