with source as (

    select * from {{ source('northscope', 'erpx_arcustomer') }}

),

renamed as (

    select
        customername,
        createddatetime,
        pricelevel,
        tradediscount,
        customerfavoriteruleen,
        glaraccountsk,
        linktoemployeesk,
        statementname,
        financechargeoptionen,
        hostsystemlink,
        lastupdated,
        createdby,
        creditlimitamount,
        pricelistheadersk,
        taxclasssk,
        isinactive,
        dataentitycompanysk,
        termsdiscavailactsk,
        invoicedeliverymethoden,
        duedategraceperiod,
        currencyid,
        checkbooksk,
        tradediscountmethoden,
        financechgactsk,
        cogsactsk,
        termsdisctakenactsk,
        paymenttermssk,
        lastuser,
        inventoryactsk,
        writeoffactsk,
        attributeclasssk,
        customerclasssk,
        discountgraceperiod,
        isonhold,
        salesactsk,
        overpmtwriteoffactsk,
        salesreturnactsk,
        financechargeamount,
        parentcustomersk,
        creditlimitoptionen,
        hasfullitemaccess,
        _fivetran_deleted,
        _fivetran_synced,
        trim(customerid) as customerid,
        trim(customersk) as customersk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
