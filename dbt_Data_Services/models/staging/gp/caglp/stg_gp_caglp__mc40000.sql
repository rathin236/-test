with source as (

    select * from {{ source('caglp_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        alovexrt,
        anwrtpwd,
        mnsumhst,
        lstsumrv,
        rprtclmd,
        defslstp,
        deffintp,
        defpurtp,
        alownwrt,
        avgexrat,
        funcridx,
        modrtpwd,
        dex_row_id,
        lstreval,
        rptgcurr,
        lstprval,
        rptxrate,
        avgclmd,
        dex_row_ts,
        lstsrval,
        lsttrxrv,
        ovrprpwd,
        rptcridx,
        alwmodrt,
        ovxrtpwd,
        aovrtvar,
        aovrptrt,
        ovrtvpwd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
