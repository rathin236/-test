with source as (

    select * from {{ source('gdvii_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_4,
        actnumbr_1,
        actnumbr_3,
        actnumbr_9,
        actnumbr_6,
        actnumbr_8,
        actnumst,
        actnumbr_5,
        dex_row_id,
        actnumbr_10,
        actnumbr_7,
        actnumbr_2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
