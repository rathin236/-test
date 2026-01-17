with source as (

    select * from {{ source('tnsus_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        actnumbr_6,
        actnumbr_3,
        actnumbr_10,
        actnumst,
        actnumbr_8,
        actnumbr_5,
        actnumbr_2,
        dex_row_id,
        actnumbr_7,
        actnumbr_4,
        actnumbr_1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
