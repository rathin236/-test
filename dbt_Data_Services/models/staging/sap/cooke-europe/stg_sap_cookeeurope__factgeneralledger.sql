with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'factgeneralledger') }}

),

renamed as (

    select

        factgeneralledgerid,
        dimcontrollingareaid,
        dimprofitcenterid,
        amountloccurrency,
        creditamountdoccurrency,
        dimpostingkeyid,
        amountdoccurrency,
        appliedexchangeratetransactioncurrency,
        dimcompanyid,
        appliedexchangeratelocalcurrency,
        ledger,
        modifiedetlrunid,
        fiscalyear,
        creditamountloccurrency,
        dimpostingdateid,
        dimlocalcurrencyid,
        referencename,
        debitamountgroupcurrency,
        dimglaccountid,
        debitcreditindicator,
        postingperiod,
        amountgroupcurrency,
        dimcostelementid,
        referencenumber,
        accountdocumentnumber,
        dimtransactioncurrencyid,
        dimgroupcurrencyid,
        debitamountdoccurrency,
        accountdocumentlinenumber,
        debitamountloccurrency,
        dimaccountsdocumenttypeid,
        creditamountgroupcurrency,
        createdetlrunid,
        appliedexchangerategroupcurrency,
        dimcostcenterid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
