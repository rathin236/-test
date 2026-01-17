with source as (

    select * from {{ source('culc1_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptxrate,
        rptgcurr,
        mnsumhst,
        alovexrt,
        lsttrxrv,
        aovrptrt,
        modrtpwd,
        ovxrtpwd,
        lstprval,
        lstreval,
        ovrprpwd,
        rptcridx,
        alownwrt,
        ovrtvpwd,
        avgclmd,
        funcridx,
        lstsrval,
        avgexrat,
        anwrtpwd,
        lstsumrv,
        defslstp,
        dex_row_id,
        alwmodrt,
        deffintp,
        rprtclmd,
        defpurtp,
        aovrtvar,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
