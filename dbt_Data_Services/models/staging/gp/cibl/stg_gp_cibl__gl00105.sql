with source as (

    select * from {{ source('cibl_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_8,
        actnumbr_5,
        actnumbr_2,
        actnumbr_7,
        dex_row_id,
        actnumbr_4,
        actnumbr_1,
        actnumbr_9,
        actnumbr_6,
        actnumst,
        actnumbr_3,
        actnumbr_10,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
