with accounts_payable_forecast as (
    select 

    trans.DATAAREAID AS CompanyName
    --,trans.VOUCHER
    --,'' AS CustomerID --For Account Payable
	,trans.ACCOUNTNUM AS VendorID --For Account Payable
	,replace(party.NAME,'|','-') AS OriginatingMasterName
	--,'' AS CustomerClass
    ,vend.VENDGROUP AS VendorClass
	,trans.CURRENCYCODE AS CurrencyID
    ,trans.INVOICE AS DocumentNumber
	--,trans.TRANSTYPE AS DocumentType
    ,enumTransType.ENUMVALUELABEL AS DocumentType
	,TO_VARCHAR(trans.DOCUMENTDATE, 'YYYY-MM-DD') AS DocumentDate
	,TO_VARCHAR(trans.TRANSDATE, 'YYYY-MM-DD') AS TransactionDate
	,TO_VARCHAR(trans.DUEDATE, 'YYYY-MM-DD') AS InvoiceDueDate
    ,SUBSTRING(gjae.LEDGERACCOUNT, 1, 6) AS AccountNumber
	,replace(mac.NAME,'|','-') AS AccountName
	--,gjae.POSTINGTYPE AS DistributionTypeNum
    ,replace(enumPostType.ENUMVALUELABEL,'|','-') AS DistributionType
    ,TO_VARCHAR(gjae.TRANSACTIONCURRENCYAMOUNT * -1, 'FM999999999999.00') AS OriginatingAmount
	,gjae.TEXT AS Reference
    ,TO_VARCHAR(trans.LASTSETTLEDATE, 'YYYY-MM-DD') AS PaidOffDate
    ,(AMOUNTCUR * -1) AS CurrentTransactionAmount


    from 
        {{ ref('int_d365_cff__accounts_payable')}} as trans
        
    join {{ ref('stg_d365__vend_table')}} vend
        on trans.ACCOUNTNUM = vend.ACCOUNTNUM 
        and vend.DATAAREAID = trans.DATAAREAID

    join {{ ref('stg_d365__dir_party_table')}} party
        on vend.PARTY = party.RECID

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
        and enumPostType.ENUMVALUE in ('4','14','71','72','84','236')
        --and enumPostType.ENUMVALUE not in ('82') -- "Cost of purchased materials received" Excluded, requested by Whitney

    where CurrentTransactionAmount <> 0
    and AccountNumber not in ('210000', '210010', '210020', '210030', '210200', '210210', '210220', '211010', '211210', '211220' )
    order by VOUCHER
)

select * from accounts_payable_forecast


