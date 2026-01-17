with source as (

    select * from {{ source('hpi_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        deffintp,
        alownwrt,
        aovrptrt,
        defslstp,
        mnsumhst,
        avgexrat,
        aovrtvar,
        rptxrate,
        lstsrval,
        funcridx,
        defpurtp,
        avgclmd,
        rptcridx,
        alwmodrt,
        ovxrtpwd,
        rptgcurr,
        lstreval,
        modrtpwd,
        dex_row_ts,
        ovrtvpwd,
        lstprval,
        dex_row_id,
        ovrprpwd,
        anwrtpwd,
        rprtclmd,
        lsttrxrv,
        lstsumrv,
        alovexrt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
