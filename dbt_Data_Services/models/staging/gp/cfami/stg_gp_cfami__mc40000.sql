with source as (

    select * from {{ source('cfami_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        aovrptrt,
        lstreval,
        avgclmd,
        ovxrtpwd,
        lstprval,
        aovrtvar,
        modrtpwd,
        alovexrt,
        mnsumhst,
        rptxrate,
        rptcridx,
        rprtclmd,
        defpurtp,
        anwrtpwd,
        deffintp,
        defslstp,
        lstsumrv,
        alwmodrt,
        dex_row_id,
        ovrtvpwd,
        lstsrval,
        alownwrt,
        rptgcurr,
        funcridx,
        avgexrat,
        lsttrxrv,
        ovrprpwd,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
