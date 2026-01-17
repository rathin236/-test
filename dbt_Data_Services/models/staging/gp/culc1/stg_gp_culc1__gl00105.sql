with source as (

    select * from {{ source('culc1_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        actnumbr_6,
        actnumbr_9,
        actnumbr_1,
        actnumbr_4,
        actnumbr_7,
        actnumbr_2,
        actnumbr_5,
        actnumst,
        actnumbr_8,
        dex_row_id,
        actnumbr_10,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
