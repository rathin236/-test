with source as (

    select * from {{ source('rbf_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        anwrtpwd,
        rptxrate,
        lstreval,
        rprtclmd,
        funcridx,
        avgexrat,
        ovrprpwd,
        lstprval,
        alownwrt,
        alwmodrt,
        lsttrxrv,
        lstsumrv,
        defslstp,
        alovexrt,
        avgclmd,
        rptgcurr,
        mnsumhst,
        rptcridx,
        aovrtvar,
        modrtpwd,
        ovrtvpwd,
        lstsrval,
        aovrptrt,
        dex_row_ts,
        defpurtp,
        ovxrtpwd,
        dex_row_id,
        deffintp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
