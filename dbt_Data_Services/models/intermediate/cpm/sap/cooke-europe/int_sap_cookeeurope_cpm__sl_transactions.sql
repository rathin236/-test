with ap_transactions as (

    select * from {{ ref('stg_sap_cookeeurope__factaccountspayable') }}

),

vendors as (

    select * from {{ ref('stg_sap_cookeeurope__dimvendor') }}

),

ar_transactions as (

    select * from {{ ref('stg_sap_cookeeurope__factaccountsreceivable') }}

),

customers as (

    select * from {{ ref('stg_sap_cookeeurope__dimcustomer') }}

),

accountspayable as (

    select

        ap_transactions.dimvendorid as originatingid,
        ap_transactions.invoicenumber,
        ap_transactions.dimcompanyid,
        ap_transactions.accountdocumentnumber,
        ap_transactions.diminvoicedateid,
        vendors.vendorname as originatingname

    from ap_transactions
    left join vendors on
        ap_transactions.dimvendorid = vendors.dimvendorid

),

accountsreceivable as (

    select

        ar_transactions.dimcustomerid as originatingid,
        ar_transactions.invoicenumber,
        ar_transactions.dimcompanyid,
        ar_transactions.accountdocumentnumber,
        ar_transactions.diminvoicedateid,
        customers.customername as originatingname

    from ar_transactions
    left join customers on
        ar_transactions.dimcustomerid = customers.dimcustomerid

),

unioned as (

    select * from accountspayable

    union all

    select * from accountsreceivable

)

select * from unioned
