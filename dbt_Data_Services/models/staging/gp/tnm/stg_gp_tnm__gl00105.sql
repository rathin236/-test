with source as (

    select * from {{ source('tnm_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_5,
        actnumbr_8,
        actnumst,
        actnumbr_10,
        dex_row_id,
        actnumbr_2,
        actnumbr_1,
        actnumbr_4,
        actnumbr_7,
        actnumbr_3,
        actnumbr_6,
        actnumbr_9,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
