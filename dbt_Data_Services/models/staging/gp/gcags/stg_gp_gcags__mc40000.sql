with source as (

    select * from {{ source('gcags_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptcridx,
        ovrprpwd,
        defpurtp,
        lstreval,
        defslstp,
        avgclmd,
        alownwrt,
        anwrtpwd,
        ovrtvpwd,
        rprtclmd,
        ovxrtpwd,
        lstsrval,
        dex_row_ts,
        alovexrt,
        aovrtvar,
        modrtpwd,
        rptgcurr,
        mnsumhst,
        lstprval,
        funcridx,
        dex_row_id,
        avgexrat,
        rptxrate,
        deffintp,
        aovrptrt,
        alwmodrt,
        lsttrxrv,
        lstsumrv,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
