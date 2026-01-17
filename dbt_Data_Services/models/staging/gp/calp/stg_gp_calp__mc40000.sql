with source as (

    select * from {{ source('calp_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        ovxrtpwd,
        lstreval,
        rptgcurr,
        ovrtvpwd,
        rprtclmd,
        aovrtvar,
        deffintp,
        lsttrxrv,
        lstsumrv,
        mnsumhst,
        avgclmd,
        rptcridx,
        lstprval,
        dex_row_ts,
        alovexrt,
        ovrprpwd,
        dex_row_id,
        aovrptrt,
        rptxrate,
        defpurtp,
        anwrtpwd,
        alwmodrt,
        alownwrt,
        avgexrat,
        lstsrval,
        modrtpwd,
        defslstp,
        funcridx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
