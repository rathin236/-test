with

source as (

    select * from {{ source('metaviewer_dbo', 'mvpm_apmodel_potaxdata') }}

),

renamed as (

    select
        id,
        refdocid,
        ponumber,
        transactiontype,
        description,
        rowindex,
        taxdetailid,
        creator,
        totalpurchases,
        receiptlinenumber,
        taxablepurchases,
        taxamount,
        itemnumber,
        matchreceiptnumber,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
