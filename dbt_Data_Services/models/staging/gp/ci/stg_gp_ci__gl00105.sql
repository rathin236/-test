with source as (

    select * from {{ source('ci_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_4,
        actnumbr_5,
        actnumst,
        actnumbr_6,
        actnumbr_7,
        actnumbr_8,
        actnumbr_10,
        actnumbr_9,
        actnumbr_1,
        actnumbr_2,
        actnumbr_3,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
