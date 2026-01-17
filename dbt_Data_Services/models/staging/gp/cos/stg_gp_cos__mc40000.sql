with source as (

    select * from {{ source('cos_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        anwrtpwd,
        rptxrate,
        lsttrxrv,
        dex_row_ts,
        lstsrval,
        ovxrtpwd,
        funcridx,
        alownwrt,
        defpurtp,
        lstreval,
        deffintp,
        avgexrat,
        avgclmd,
        rptcridx,
        alovexrt,
        lstprval,
        rptgcurr,
        aovrtvar,
        lstsumrv,
        ovrtvpwd,
        dex_row_id,
        rprtclmd,
        aovrptrt,
        alwmodrt,
        modrtpwd,
        defslstp,
        ovrprpwd,
        mnsumhst,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
