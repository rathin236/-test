with source as (

    select * from {{ source('lbfl_dbo', 'gl00105') }}

),

renamed as (

    select
        actindx,
        actnumst,
        actnumbr_5,
        actnumbr_8,
        actnumbr_2,
        actnumbr_4,
        actnumbr_7,
        actnumbr_1,
        actnumbr_6,
        dex_row_id,
        actnumbr_9,
        actnumbr_10,
        actnumbr_3,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
