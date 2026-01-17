with source as (

    select * from {{ source('cagsf_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        lstsumrv,
        ovrtvpwd,
        mnsumhst,
        alovexrt,
        defpurtp,
        alownwrt,
        funcridx,
        rptxrate,
        aovrtvar,
        ovrprpwd,
        avgexrat,
        defslstp,
        alwmodrt,
        aovrptrt,
        modrtpwd,
        rptcridx,
        dex_row_ts,
        anwrtpwd,
        avgclmd,
        dex_row_id,
        lsttrxrv,
        lstprval,
        lstreval,
        rprtclmd,
        ovxrtpwd,
        lstsrval,
        deffintp,
        rptgcurr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
