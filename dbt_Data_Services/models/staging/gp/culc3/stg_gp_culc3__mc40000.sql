with source as (

    select * from {{ source('culc3_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        aovrtvar,
        ovrtvpwd,
        lstsrval,
        ovrprpwd,
        dex_row_ts,
        rptgcurr,
        dex_row_id,
        deffintp,
        modrtpwd,
        rprtclmd,
        aovrptrt,
        alwmodrt,
        lstprval,
        rptxrate,
        defpurtp,
        lsttrxrv,
        lstsumrv,
        mnsumhst,
        lstreval,
        anwrtpwd,
        ovxrtpwd,
        avgexrat,
        funcridx,
        avgclmd,
        defslstp,
        alownwrt,
        rptcridx,
        alovexrt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
