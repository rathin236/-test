with source as (

    select * from {{ source('tnscl_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_6,
        actnumbr_9,
        actnumbr_3,
        actnumbr_8,
        actnumst,
        actnumbr_2,
        actnumbr_5,
        actnumbr_10,
        actnumbr_7,
        actnumbr_1,
        actnumbr_4,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
