with source as (

    select * from {{ source('tnsus_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptxrate,
        avgexrat,
        lstsrval,
        funcridx,
        lstsumrv,
        alownwrt,
        dex_row_ts,
        avgclmd,
        dex_row_id,
        modrtpwd,
        anwrtpwd,
        rptcridx,
        alovexrt,
        defslstp,
        ovrprpwd,
        mnsumhst,
        defpurtp,
        rptgcurr,
        lsttrxrv,
        ovrtvpwd,
        aovrptrt,
        deffintp,
        alwmodrt,
        lstprval,
        ovxrtpwd,
        lstreval,
        rprtclmd,
        aovrtvar,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
