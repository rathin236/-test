with source as (

    select * from {{ source('slade_sap', 'skat') }}

),

renamed as (

    select

        mcod1,
        ktopl,
        saknr,
        txt20,
        spras,
        mandt,
        txt50,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
