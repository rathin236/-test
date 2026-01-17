with source as (

    select * from {{ source('causa_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_2,
        actnumbr_1,
        actnumbr_4,
        actnumbr_7,
        actnumbr_3,
        actnumbr_6,
        dex_row_id,
        actnumbr_9,
        actnumbr_5,
        actnumst,
        actnumbr_8,
        actnumbr_10,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
