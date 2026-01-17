with source as (

    select * from {{ source('slade_sap', 'cskt') }}

),

renamed as (

    select

        ltext,
        mandt,
        spras,
        kokrs,
        datbi,
        ktext,
        datbi_simp_dt,
        kostl,
        mctxt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
