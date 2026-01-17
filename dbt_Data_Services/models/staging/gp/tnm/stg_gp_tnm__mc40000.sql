with source as (

    select * from {{ source('tnm_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        modrtpwd,
        alwmodrt,
        lstsumrv,
        ovxrtpwd,
        lstreval,
        rptgcurr,
        alovexrt,
        rptcridx,
        funcridx,
        defpurtp,
        avgclmd,
        avgexrat,
        deffintp,
        dex_row_ts,
        alownwrt,
        defslstp,
        lsttrxrv,
        lstsrval,
        mnsumhst,
        rptxrate,
        ovrtvpwd,
        aovrtvar,
        rprtclmd,
        anwrtpwd,
        ovrprpwd,
        aovrptrt,
        lstprval,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
