with source as (

    select * from {{ source('hsi_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        dex_row_id,
        avgexrat,
        ovxrtpwd,
        rprtclmd,
        alownwrt,
        lstsumrv,
        aovrptrt,
        funcridx,
        modrtpwd,
        avgclmd,
        lstsrval,
        anwrtpwd,
        rptcridx,
        ovrtvpwd,
        defpurtp,
        ovrprpwd,
        lsttrxrv,
        alwmodrt,
        defslstp,
        aovrtvar,
        rptgcurr,
        alovexrt,
        dex_row_ts,
        mnsumhst,
        rptxrate,
        lstreval,
        deffintp,
        lstprval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
