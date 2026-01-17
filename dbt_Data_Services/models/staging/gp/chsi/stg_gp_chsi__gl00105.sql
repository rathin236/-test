with source as (

    select * from {{ source('chsi_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_2,
        actnumst,
        actnumbr_10,
        actnumbr_5,
        actnumbr_8,
        actnumbr_7,
        actnumbr_9,
        dex_row_id,
        actnumbr_1,
        actnumbr_4,
        actnumbr_3,
        actnumbr_6,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
