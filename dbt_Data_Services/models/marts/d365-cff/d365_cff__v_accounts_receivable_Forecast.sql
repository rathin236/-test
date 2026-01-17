with accounts_receivable_forecast as (
    select 

    trans.DATAAREAID AS CompanyName
    --,trans.VOUCHER
    ,trans.ACCOUNTNUM AS CustomerID --For Account Payable
    --,'' AS VendorID
	,replace(party.NAME,'|','-') AS OriginatingMasterName
	,cust.CUSTGROUP AS CustomerClass
    --,'' AS VendorClass
	,trans.CURRENCYCODE AS CurrencyID
    ,trans.INVOICE AS DocumentNumber
	--,trans.TRANSTYPE AS DocumentType
    ,enumTransType.ENUMVALUELABEL AS DocumentType
	,TO_VARCHAR(trans.DOCUMENTDATE, 'YYYY-MM-DD') AS DocumentDate
	,TO_VARCHAR(trans.TRANSDATE, 'YYYY-MM-DD') AS TransactionDate
	,TO_VARCHAR(trans.DUEDATE, 'YYYY-MM-DD') AS InvoiceDueDate
    ,SUBSTRING(gjae.LEDGERACCOUNT, 1, 6) AS AccountNumber
    ,replace(mac.NAME,'|','-') AS AccountName
	--,gjae.POSTINGTYPE AS DistributionType
    ,replace(enumPostType.ENUMVALUELABEL,'|','-') AS DistributionType
    ,TO_VARCHAR(gjae.TRANSACTIONCURRENCYAMOUNT * -1, 'FM999999999999.00') AS OriginatingAmount
	,gjae.TEXT AS Reference
    ,TO_VARCHAR(trans.LASTSETTLEDATE, 'YYYY-MM-DD') AS PaidOffDate
    ,(trans.AMOUNTCUR * -1) AS CurrentTransactionAmount
    

    from 
        {{ ref('int_d365_cff__accounts_receivable')}} as trans
    
    
    join {{ ref('stg_d365__cust_table')}} cust
        on trans.ACCOUNTNUM = cust.ACCOUNTNUM 
        and cust.DATAAREAID = trans.DATAAREAID

    join {{ ref('stg_d365__dir_party_table')}} party
        on cust.PARTY = party.RECID

    join {{ ref('stg_d365__general_journal_entry')}} gje
        on gje.SUBLEDGERVOUCHER = trans.VOUCHER

    join {{ ref('stg_d365__general_journal_account_entry')}} gjae
        on gjae.GENERALJOURNALENTRY = gje.RECID

    join {{ref('stg_d365__main_account')}} mac
        on substring(gjae.LEDGERACCOUNT, 1, 6) = mac.mainaccountid

    join {{ref('stg_d365__fds_enum_table')}} enumTransType
        on trans.TRANSTYPE = enumTransType.ENUMVALUE
        and enumTransType.ENUMNAME in ('LedgerTransType')

    join {{ref('stg_d365__fds_enum_table')}} enumPostType
        on gjae.POSTINGTYPE = enumPostType.ENUMVALUE
        and enumPostType.ENUMNAME in ('LedgerPostingType')
        and enumPostType.ENUMVALUE in ('4','14','32','51')

    WHERE CurrentTransactionAmount <> 0
    order by VOUCHER
)

select * from accounts_receivable_forecast
