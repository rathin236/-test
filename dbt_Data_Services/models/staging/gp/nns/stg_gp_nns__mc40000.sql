with source as (

    select * from {{ source('nns_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        anwrtpwd,
        dex_row_id,
        funcridx,
        deffintp,
        rprtclmd,
        alwmodrt,
        defslstp,
        lstsumrv,
        avgexrat,
        aovrtvar,
        defpurtp,
        mnsumhst,
        modrtpwd,
        rptxrate,
        dex_row_ts,
        rptgcurr,
        aovrptrt,
        rptcridx,
        lstprval,
        lsttrxrv,
        avgclmd,
        ovrprpwd,
        ovxrtpwd,
        lstsrval,
        alownwrt,
        ovrtvpwd,
        lstreval,
        alovexrt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
