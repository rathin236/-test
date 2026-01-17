with source as (

    select * from {{ source('sti_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        defslstp,
        aovrptrt,
        deffintp,
        alownwrt,
        defpurtp,
        mnsumhst,
        alovexrt,
        ovrprpwd,
        anwrtpwd,
        dex_row_id,
        ovrtvpwd,
        rprtclmd,
        aovrtvar,
        lsttrxrv,
        lstsumrv,
        dex_row_ts,
        rptgcurr,
        rptxrate,
        modrtpwd,
        alwmodrt,
        ovxrtpwd,
        lstsrval,
        funcridx,
        lstprval,
        rptcridx,
        avgexrat,
        avgclmd,
        lstreval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
