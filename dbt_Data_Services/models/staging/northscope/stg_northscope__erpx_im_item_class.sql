with source as (

    select * from {{ source('northscope', 'erpx_imitemclass') }}

),

renamed as (

    select
        lotholdreturn,
        costgroupsk,
        invoffsetactsk,
        salesreturnsactsk,
        expirationdays,
        dataentitycompanysk,
        unrealpurchpricevaractsk,
        varianceactsk,
        attributeclasssk,
        transferfrtaccrualglaccountsk,
        weightdecimals,
        damagedactsk,
        freightrevenueactsk,
        lastupdated,
        brokerageaccrualactsk,
        itemclasssk,
        markdownactsk,
        assemblyvaractsk,
        inactive,
        purchpricevaractsk,
        inuseactsk,
        freightaccrualcreditactsk,
        inserviceactsk,
        lotholdnew,
        brokeragewriteoffactsk,
        salesactsk,
        unitdecimals,
        lastuser,
        classid,
        isvisibletowms,
        transferfrtexpenseglaccountsk,
        brokerageexpactsk,
        inventoryactsk,
        hostsystemlink,
        manageitemsbyen,
        freightaccrualdebitactsk,
        cogsactsk,
        depreciationactsk,
        inventoryrtnactsk,
        trackmethoden,
        description,
        dropshipitemsactsk,
        taxableforsales,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
