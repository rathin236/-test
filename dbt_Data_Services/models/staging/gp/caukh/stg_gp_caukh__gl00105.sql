with source as (

    select * from {{ source('caukh_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        actnumbr_4,
        dex_row_id,
        actnumbr_1,
        actnumbr_7,
        actnumbr_5,
        actnumbr_2,
        actnumbr_8,
        actnumst,
        actnumbr_10,
        actnumbr_6,
        actnumbr_3,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
