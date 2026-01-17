with source as (

    select * from {{ source('gdvc_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumst,
        actnumbr_2,
        actnumbr_10,
        actnumbr_7,
        actnumbr_4,
        actnumbr_1,
        actnumbr_9,
        actnumbr_6,
        actnumbr_3,
        actnumbr_8,
        dex_row_id,
        actnumbr_5,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
