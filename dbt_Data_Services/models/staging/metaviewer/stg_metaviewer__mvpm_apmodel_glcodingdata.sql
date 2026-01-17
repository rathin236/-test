with

source as (

    select * from {{ source('metaviewer_dbo', 'mvpm_apmodel_glcodingdata') }}

),

renamed as (

    select
        id,
        refdocid,
        transactiontype,
        description,
        rowindex,
        taxdetailid,
        creditamount,
        sys_lastchangedate,
        creator,
        accountnumber,
        distref,
        paytotal,
        extendedprice,
        sys_createdate,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
