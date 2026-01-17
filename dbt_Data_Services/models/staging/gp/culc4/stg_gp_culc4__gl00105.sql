with source as (

    select * from {{ source('culc4_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_10,
        actnumbr_2,
        actnumbr_5,
        actnumst,
        actnumbr_8,
        actnumbr_1,
        actnumbr_4,
        actnumbr_7,
        actnumbr_6,
        actnumbr_9,
        dex_row_id,
        actnumbr_3,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
