with

source as (

    select {{ convert_columns('nb681_dbo', 'mc40000') }}
    from {{ source('nb681_dbo', 'mc40000') }}

),

renamed as (

    select
        funlcurr,
        ovxrtpwd,
        aovrtvar,
        alownwrt,
        rprtclmd,
        rptcridx,
        ovrprpwd,
        lstsumrv,
        alwmodrt,
        lstsrval,
        rptgcurr,
        ovrtvpwd,
        avgclmd,
        defslstp,
        rptxrate,
        anwrtpwd,
        mnsumhst,
        defpurtp,
        funcridx,
        avgexrat,
        alovexrt,
        lstreval,
        deffintp,
        modrtpwd,
        dex_row_id,
        dex_row_ts,
        aovrptrt,
        lsttrxrv,
        lstprval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
