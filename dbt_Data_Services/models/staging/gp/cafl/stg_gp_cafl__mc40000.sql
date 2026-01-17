with source as (

    select * from {{ source('cafl_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        lstsrval,
        ovrprpwd,
        deffintp,
        defslstp,
        lstprval,
        rptgcurr,
        lsttrxrv,
        lstsumrv,
        anwrtpwd,
        ovrtvpwd,
        alwmodrt,
        aovrptrt,
        dex_row_ts,
        aovrtvar,
        mnsumhst,
        funcridx,
        dex_row_id,
        rprtclmd,
        lstreval,
        modrtpwd,
        ovxrtpwd,
        rptcridx,
        rptxrate,
        alownwrt,
        alovexrt,
        defpurtp,
        avgexrat,
        avgclmd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
