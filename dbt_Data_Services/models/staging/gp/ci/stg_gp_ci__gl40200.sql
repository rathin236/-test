with source as (

    select * from {{ source('ci_dbo', 'gl40200') }}

),

renamed as (

    select
        sgmntid,
        sgmtnumb,
        noteindx,
        segcount,
        dex_row_ts,
        dscriptn,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
