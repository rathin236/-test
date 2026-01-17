with source as (
    select {{ convert_columns('cph_dbo', 'mc40000') }}
    from {{ source('cph_dbo', 'mc40000') }}
),

renamed as (
    select
        funlcurr,
        ovrprpwd,
        alownwrt,
        aovrtvar,
        rprtclmd,
        rptcridx,
        ovxrtpwd,
        aovrptrt,
        lstsrval,
        dex_row_id,
        lsttrxrv,
        lstsumrv,
        defpurtp,
        modrtpwd,
        deffintp,
        lstreval,
        alovexrt,
        lstprval,
        mnsumhst,
        dex_row_ts,
        rptxrate,
        anwrtpwd,
        funcridx,
        avgexrat,
        defslstp,
        alwmodrt,
        ovrtvpwd,
        avgclmd,
        rptgcurr,
        _fivetran_deleted,
        _fivetran_synced

    from source
)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
