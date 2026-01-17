with source as (

    select * from {{ source('cap_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        rptxrate,
        alownwrt,
        aovrptrt,
        modrtpwd,
        lstreval,
        alovexrt,
        mnsumhst,
        rptcridx,
        anwrtpwd,
        dex_row_id,
        lstsrval,
        defslstp,
        deffintp,
        dex_row_ts,
        alwmodrt,
        ovrprpwd,
        funcridx,
        rprtclmd,
        lstprval,
        avgexrat,
        avgclmd,
        defpurtp,
        ovrtvpwd,
        rptgcurr,
        aovrtvar,
        lsttrxrv,
        lstsumrv,
        ovxrtpwd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
