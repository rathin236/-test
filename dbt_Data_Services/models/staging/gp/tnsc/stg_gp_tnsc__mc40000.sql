with source as (

    select * from {{ source('tnsc_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        modrtpwd,
        lstsrval,
        aovrtvar,
        rptcridx,
        alovexrt,
        ovrtvpwd,
        mnsumhst,
        dex_row_id,
        aovrptrt,
        alwmodrt,
        dex_row_ts,
        rptgcurr,
        alownwrt,
        rptxrate,
        ovxrtpwd,
        avgexrat,
        avgclmd,
        deffintp,
        funcridx,
        lstreval,
        defpurtp,
        lsttrxrv,
        lstsumrv,
        lstprval,
        ovrprpwd,
        rprtclmd,
        anwrtpwd,
        defslstp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
