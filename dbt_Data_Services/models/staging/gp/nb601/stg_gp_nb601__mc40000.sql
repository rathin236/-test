with source as (

    select * from {{ source('nb601_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        defpurtp,
        anwrtpwd,
        avgclmd,
        deffintp,
        lstsrval,
        alovexrt,
        lsttrxrv,
        defslstp,
        lstsumrv,
        dex_row_ts,
        lstreval,
        ovrtvpwd,
        rprtclmd,
        rptgcurr,
        rptcridx,
        alownwrt,
        lstprval,
        ovrprpwd,
        rptxrate,
        alwmodrt,
        ovxrtpwd,
        aovrtvar,
        modrtpwd,
        avgexrat,
        dex_row_id,
        aovrptrt,
        funcridx,
        mnsumhst,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
