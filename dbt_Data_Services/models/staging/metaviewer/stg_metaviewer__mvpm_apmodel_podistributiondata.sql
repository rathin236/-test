with

source as (

    select * from {{ source('metaviewer_dbo', 'mvpm_apmodel_podistributiondata') }}

),

renamed as (

    select
        id,
        refdocid,
        distref,
        transactiontype,
        description,
        rowindex,
        creditamount,
        creator,
        debitamount,
        accountnumber,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'
)

select * from renamed
