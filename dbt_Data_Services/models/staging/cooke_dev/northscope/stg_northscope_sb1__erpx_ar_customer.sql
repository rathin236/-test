with source as (

    select * from {{ source('northscope_sb1', 'erpx_arcustomer') }}

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
        customerid,
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
        customersk,
        salesreturnactsk,
        financechargeamount,
        parentcustomersk,
        creditlimitoptionen,
        hasfullitemaccess,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
