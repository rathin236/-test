with source as (

    select * from {{ source('stusa_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        anwrtpwd,
        avgexrat,
        deffintp,
        avgclmd,
        alownwrt,
        lstreval,
        defslstp,
        dex_row_id,
        rprtclmd,
        defpurtp,
        modrtpwd,
        aovrptrt,
        alwmodrt,
        rptxrate,
        rptgcurr,
        lstsrval,
        aovrtvar,
        mnsumhst,
        alovexrt,
        ovxrtpwd,
        dex_row_ts,
        ovrprpwd,
        lstprval,
        funcridx,
        rptcridx,
        lsttrxrv,
        lstsumrv,
        ovrtvpwd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
