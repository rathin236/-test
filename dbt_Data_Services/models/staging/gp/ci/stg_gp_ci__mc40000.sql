with source as (

    select * from {{ source('ci_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptcridx,
        lstsrval,
        lsttrxrv,
        ovrprpwd,
        lstsumrv,
        mnsumhst,
        avgclmd,
        ovrtvpwd,
        alovexrt,
        aovrtvar,
        rptxrate,
        defslstp,
        avgexrat,
        funcridx,
        rptgcurr,
        anwrtpwd,
        aovrptrt,
        lstprval,
        alownwrt,
        deffintp,
        modrtpwd,
        lstreval,
        dex_row_id,
        defpurtp,
        dex_row_ts,
        alwmodrt,
        ovxrtpwd,
        rprtclmd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
