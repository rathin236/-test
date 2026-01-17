with source as (

    select * from {{ source('ccaus_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        actnumbr_6,
        actnumbr_3,
        actnumbr_8,
        actnumbr_5,
        actnumst,
        actnumbr_2,
        actnumbr_10,
        actnumbr_7,
        actnumbr_4,
        actnumbr_1,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
