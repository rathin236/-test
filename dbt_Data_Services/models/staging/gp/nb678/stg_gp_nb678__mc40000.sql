with source as (

    select * from {{ source('nb678_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        aovrtvar,
        lstprval,
        lsttrxrv,
        ovrtvpwd,
        dex_row_ts,
        alovexrt,
        mnsumhst,
        ovrprpwd,
        defpurtp,
        dex_row_id,
        lstsrval,
        alwmodrt,
        alownwrt,
        defslstp,
        lstreval,
        rprtclmd,
        modrtpwd,
        avgclmd,
        rptxrate,
        rptcridx,
        anwrtpwd,
        aovrptrt,
        lstsumrv,
        deffintp,
        funcridx,
        ovxrtpwd,
        avgexrat,
        rptgcurr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
