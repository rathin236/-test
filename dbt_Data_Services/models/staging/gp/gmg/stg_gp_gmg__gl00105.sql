with source as (

    select * from {{ source('gmg_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_6,
        actnumbr_3,
        dex_row_id,
        actnumbr_9,
        actnumbr_8,
        actnumbr_10,
        actnumst,
        actnumbr_5,
        actnumbr_2,
        actnumbr_1,
        actnumbr_7,
        actnumbr_4,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
