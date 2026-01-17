with source as (

    select * from {{ source('gmg_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        aovrtvar,
        rptxrate,
        funcridx,
        ovrprpwd,
        defpurtp,
        rprtclmd,
        avgexrat,
        alovexrt,
        defslstp,
        lstreval,
        rptgcurr,
        dex_row_ts,
        avgclmd,
        lstprval,
        rptcridx,
        lsttrxrv,
        mnsumhst,
        deffintp,
        lstsumrv,
        alwmodrt,
        aovrptrt,
        ovxrtpwd,
        alownwrt,
        modrtpwd,
        anwrtpwd,
        dex_row_id,
        ovrtvpwd,
        lstsrval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
