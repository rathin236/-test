with source as (

    select * from {{ source('cos_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        dex_row_id,
        actnumbr_9,
        actnumbr_6,
        actnumbr_5,
        actnumbr_2,
        actnumst,
        actnumbr_8,
        actnumbr_7,
        actnumbr_10,
        actnumbr_4,
        actnumbr_1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
