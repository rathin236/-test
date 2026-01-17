with source as (

    select * from {{ source('casl_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        lstsumrv,
        alownwrt,
        anwrtpwd,
        defslstp,
        deffintp,
        aovrptrt,
        rprtclmd,
        lstreval,
        rptxrate,
        defpurtp,
        alovexrt,
        lstprval,
        lsttrxrv,
        alwmodrt,
        rptgcurr,
        avgclmd,
        dex_row_ts,
        modrtpwd,
        ovxrtpwd,
        mnsumhst,
        ovrprpwd,
        funcridx,
        lstsrval,
        dex_row_id,
        avgexrat,
        ovrtvpwd,
        aovrtvar,
        rptcridx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
