with source as (

    select * from {{ source('causa_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        ovxrtpwd,
        aovrptrt,
        lstprval,
        modrtpwd,
        anwrtpwd,
        rptgcurr,
        alownwrt,
        ovrtvpwd,
        lstsrval,
        alovexrt,
        rprtclmd,
        ovrprpwd,
        lstreval,
        dex_row_id,
        alwmodrt,
        deffintp,
        defslstp,
        funcridx,
        rptxrate,
        lsttrxrv,
        lstsumrv,
        rptcridx,
        avgexrat,
        avgclmd,
        aovrtvar,
        defpurtp,
        mnsumhst,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
