with source as (

    select * from {{ source('cpqln_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        ovrtvpwd,
        dex_row_ts,
        funcridx,
        rprtclmd,
        avgexrat,
        lsttrxrv,
        defpurtp,
        alwmodrt,
        lstsrval,
        defslstp,
        modrtpwd,
        dex_row_id,
        ovrprpwd,
        alownwrt,
        lstprval,
        alovexrt,
        anwrtpwd,
        lstsumrv,
        lstreval,
        avgclmd,
        aovrptrt,
        deffintp,
        rptxrate,
        ovxrtpwd,
        mnsumhst,
        rptcridx,
        rptgcurr,
        aovrtvar,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
