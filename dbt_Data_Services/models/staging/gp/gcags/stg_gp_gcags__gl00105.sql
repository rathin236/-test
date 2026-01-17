with source as (

    select * from {{ source('gcags_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_7,
        actnumbr_10,
        actnumbr_4,
        actnumbr_8,
        actnumbr_5,
        actnumst,
        actnumbr_2,
        actnumbr_3,
        dex_row_id,
        actnumbr_1,
        actnumbr_9,
        actnumbr_6,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
