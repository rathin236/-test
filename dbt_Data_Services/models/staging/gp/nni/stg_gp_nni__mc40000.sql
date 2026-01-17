with source as (

    select * from {{ source('nni_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rprtclmd,
        funcridx,
        lstsrval,
        dex_row_ts,
        modrtpwd,
        defslstp,
        rptxrate,
        aovrtvar,
        mnsumhst,
        lsttrxrv,
        lstsumrv,
        ovrprpwd,
        lstprval,
        alwmodrt,
        anwrtpwd,
        aovrptrt,
        lstreval,
        alownwrt,
        rptgcurr,
        dex_row_id,
        rptcridx,
        defpurtp,
        ovrtvpwd,
        alovexrt,
        avgexrat,
        avgclmd,
        ovxrtpwd,
        deffintp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
