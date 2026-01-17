with source as (

    select * from {{ source('kcs_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_8,
        actnumbr_10,
        actnumst,
        actnumbr_5,
        actnumbr_2,
        actnumbr_4,
        actnumbr_1,
        actnumbr_7,
        actnumbr_6,
        actnumbr_3,
        actnumbr_9,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
