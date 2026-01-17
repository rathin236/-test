with source as (

    select * from {{ source('caglp_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        actnumbr_9,
        actnumbr_6,
        actnumbr_1,
        actnumbr_7,
        dex_row_id,
        actnumbr_4,
        actnumbr_10,
        actnumbr_2,
        actnumbr_8,
        actnumbr_5,
        actnumst,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
