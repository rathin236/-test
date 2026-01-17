with source as (

    select * from {{ source('culc4_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        aovrtvar,
        lstsrval,
        avgexrat,
        avgclmd,
        dex_row_ts,
        modrtpwd,
        ovxrtpwd,
        funcridx,
        alovexrt,
        rptcridx,
        lstprval,
        lsttrxrv,
        lstsumrv,
        rptxrate,
        defpurtp,
        lstreval,
        defslstp,
        deffintp,
        ovrprpwd,
        alownwrt,
        rptgcurr,
        ovrtvpwd,
        dex_row_id,
        rprtclmd,
        anwrtpwd,
        aovrptrt,
        alwmodrt,
        mnsumhst,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
