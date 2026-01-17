with source as (

    select * from {{ source('nb601_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_1,
        actnumbr_2,
        actnumbr_3,
        actnumbr_4,
        actnumbr_5,
        actnumbr_6,
        actnumst,
        actnumbr_7,
        actnumbr_9,
        actnumbr_8,
        actnumbr_10,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
