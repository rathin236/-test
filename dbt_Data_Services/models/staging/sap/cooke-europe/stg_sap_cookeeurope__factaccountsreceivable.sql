with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'factaccountsreceivable') }}

),

renamed as (

    select

        factaccountsreceivableid,
        dimcreditcontrolareaid,
        modifiedetlrunid,
        appliedexchangeratelocalcurrency,
        dimsalesgroupid,
        dimoutstandingperiodid,
        dimduedateid,
        fiscalyear,
        amountgroupcurrency,
        invoicenumber,
        appliedexchangerategroupcurrency,
        amountdoccurrency,
        dimtransactioncurrencyid,
        dimgroupcurrencyid,
        dimpaymentdateid,
        dimcustomerid,
        assignmenttype,
        accountdocumentnumber,
        dimpaymenttermsid,
        dimglaccountid,
        createdetlrunid,
        accountdocumentlinenumber,
        netpaymenttermsperiod,
        dimpostingkeyid,
        dimaccountsdocumenttypeid,
        dimlocalcurrencyid,
        dimcompanyid,
        appliedexchangeratetransactioncurrency,
        diminvoicedateid,
        dimoutstandingstatusid,
        clearingdocumentnumber,
        amountlocalcurrency,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
