with source as (

    select * from {{ source('tnscl_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        ovrtvpwd,
        rptgcurr,
        dex_row_ts,
        dex_row_id,
        lstprval,
        aovrtvar,
        defslstp,
        modrtpwd,
        lstsrval,
        alwmodrt,
        mnsumhst,
        aovrptrt,
        ovrprpwd,
        rprtclmd,
        anwrtpwd,
        avgexrat,
        alownwrt,
        lstreval,
        rptxrate,
        avgclmd,
        funcridx,
        ovxrtpwd,
        defpurtp,
        alovexrt,
        lstsumrv,
        lsttrxrv,
        deffintp,
        rptcridx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
