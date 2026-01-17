with source as (

    select * from {{ source('tns_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        dex_row_ts,
        rptgcurr,
        dex_row_id,
        lsttrxrv,
        avgexrat,
        avgclmd,
        funcridx,
        lstsrval,
        ovrprpwd,
        ovxrtpwd,
        rprtclmd,
        ovrtvpwd,
        lstprval,
        anwrtpwd,
        mnsumhst,
        lstsumrv,
        lstreval,
        defslstp,
        alownwrt,
        alovexrt,
        aovrtvar,
        deffintp,
        rptxrate,
        rptcridx,
        defpurtp,
        modrtpwd,
        aovrptrt,
        alwmodrt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
