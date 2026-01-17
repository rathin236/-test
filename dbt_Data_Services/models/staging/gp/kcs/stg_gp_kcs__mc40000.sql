with source as (

    select * from {{ source('kcs_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        alovexrt,
        ovxrtpwd,
        lstreval,
        aovrtvar,
        rptcridx,
        anwrtpwd,
        mnsumhst,
        alwmodrt,
        lstprval,
        aovrptrt,
        rptxrate,
        dex_row_id,
        defslstp,
        dex_row_ts,
        alownwrt,
        lsttrxrv,
        lstsumrv,
        modrtpwd,
        funcridx,
        ovrprpwd,
        defpurtp,
        lstsrval,
        ovrtvpwd,
        avgexrat,
        rprtclmd,
        avgclmd,
        deffintp,
        rptgcurr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
