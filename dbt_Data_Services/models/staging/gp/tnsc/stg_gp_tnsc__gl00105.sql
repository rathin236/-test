with source as (

    select * from {{ source('tnsc_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumst,
        actnumbr_2,
        actnumbr_5,
        actnumbr_3,
        actnumbr_8,
        actnumbr_10,
        actnumbr_6,
        actnumbr_9,
        actnumbr_7,
        dex_row_id,
        actnumbr_1,
        actnumbr_4,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
