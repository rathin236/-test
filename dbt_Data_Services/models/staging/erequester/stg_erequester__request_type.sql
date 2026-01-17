with

source as (

    select * from {{ source('erequester_dbo', 'requesttype') }}

),

renamed as (

    select
        requesttypeid,
        companyid,
        serviceforexpense,
        requireuserdef1,
        lastupdatedbyuserid,
        blanketrequest,
        donotpostvouchertoacctsys,
        transfernotes,
        reverseqtyncostlabel,
        expensemanagement,
        createddate,
        autoreceive,
        batchnumber,
        batchfrequency,
        documenttitle,
        soitemlocationequalscustomerid,
        limitcustomfieldsbyexpensetype,
        notificationdays,
        usecapitalproject,
        fillableform,
        useunlisteditemid,
        usecustomeridfromdept,
        invoiceapproval,
        allowmemoline,
        allowperdiem,
        stockrequest,
        authmethod,
        usecustomerid,
        deleted,
        specifybatchnumber,
        vendornameaboveid,
        itemlocation,
        shipinvoicebatchbatchnumber,
        billtolocationid,
        perdiemrate,
        billtolocationidstring,
        receipttype,
        threshold,
        unlisteditemid,
        noreqlineattachments,
        uselistpricewhenavailable,
        allowitemtypes,
        soitemlocation,
        mileagerate,
        specifyshipinvoicebatchnumber,
        active,
        ordertype,
        salesorder,
        createstandalonepo,
        usevendorforlocation,
        roibatchfrequency,
        manageblanketinacctsys,
        createdbyuserid,
        purchasetype,
        limitcustomfields,
        autocloseonposting,
        lastupdateddate,
        notifyproxyapprover,
        allowmileage,
        emshowclient,
        preventpricechangesforlisteditems,
        showrequisitionnumbers,
        manualpoentry,
        aprautonumber,
        masterpo,
        autoclose,
        description,
        salesordertype,
        vendorclassid,
        usebillingaddress,
        invoicetype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
