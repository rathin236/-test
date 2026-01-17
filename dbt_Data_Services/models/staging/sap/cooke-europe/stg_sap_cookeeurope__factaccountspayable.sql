with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'factaccountspayable') }}

),

renamed as (

    select

        factaccountspayableid,
        dimpostingkeyid,
        dimtransactioncurrencyid,
        appliedexchangeratetransactioncurrency,
        dimlocalcurrencyid,
        diminvoicedateid,
        netpaymenttermsperiod,
        dimaccountsdocumenttypeid,
        dimcreditcontrolareaid,
        dimgroupcurrencyid,
        appliedexchangeratelocalcurrency,
        amountlocalcurrency,
        dimcompanyid,
        invoicenumber,
        dimglaccountid,
        createdetlrunid,
        dimoutstandingperiodid,
        accountdocumentlinenumber,
        fiscalyear,
        accountdocumentnumber,
        modifiedetlrunid,
        appliedexchangerategroupcurrency,
        clearingdocumentnumber,
        dimpaymentdateid,
        amountgroupcurrency,
        assignmenttype,
        dimvendorid,
        dimpaymenttermsid,
        dimoutstandingstatusid,
        amountdoccurrency,
        dimduedateid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
