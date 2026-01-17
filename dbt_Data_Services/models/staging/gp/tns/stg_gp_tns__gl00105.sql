with source as (

    select * from {{ source('tns_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        actnumbr_5,
        actnumst,
        actnumbr_8,
        actnumbr_2,
        actnumbr_4,
        actnumbr_7,
        actnumbr_10,
        actnumbr_1,
        actnumbr_6,
        dex_row_id,
        actnumbr_9,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
