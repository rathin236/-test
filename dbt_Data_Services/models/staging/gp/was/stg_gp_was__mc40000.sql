with source as (

    select * from {{ source('was_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptxrate,
        alownwrt,
        aovrptrt,
        lstsumrv,
        alovexrt,
        mnsumhst,
        defpurtp,
        lstreval,
        ovxrtpwd,
        deffintp,
        lstsrval,
        rprtclmd,
        funcridx,
        modrtpwd,
        alwmodrt,
        lsttrxrv,
        rptgcurr,
        ovrtvpwd,
        lstprval,
        aovrtvar,
        dex_row_id,
        rptcridx,
        anwrtpwd,
        ovrprpwd,
        avgclmd,
        dex_row_ts,
        avgexrat,
        defslstp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
