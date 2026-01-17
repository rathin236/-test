with source as (

    select * from {{ source('cai_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rprtclmd,
        dex_row_ts,
        modrtpwd,
        lstprval,
        avgexrat,
        lsttrxrv,
        ovxrtpwd,
        mnsumhst,
        funcridx,
        alownwrt,
        alovexrt,
        rptxrate,
        aovrtvar,
        rptgcurr,
        avgclmd,
        aovrptrt,
        alwmodrt,
        defpurtp,
        lstsumrv,
        rptcridx,
        defslstp,
        deffintp,
        lstreval,
        dex_row_id,
        ovrtvpwd,
        ovrprpwd,
        lstsrval,
        anwrtpwd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
