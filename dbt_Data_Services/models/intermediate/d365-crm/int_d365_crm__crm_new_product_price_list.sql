with crmpnewpricelist as ( --cte to get all crm products which pricelist not yet created
    select distinct
        'NEW' as status,
        'CRM' as source,
        'TNSF' as company,
        plv.name as pricelist,
        plv.pricelevelid as pricelistid,
        prd2._defaultuomid_value as unit,
        '0' as amount,
        txc.currencyname as currency,
        'No Control' as quantsellopt,
        'None' as roundpolicy,
        prd2.productid as productuid,
        prd2._defaultuomscheduleid_value as uomscheduleid,
        trim(prd2.productnumber) as productid
    from
        {{ ref('stg_crm_dev3__product') }} as prd2
    inner join
        {{ ref('stg_crm_dev3__pricelevel') }} as plv
        on (plv.pricelevelid = '6af703ef-66c3-e711-a94c-000d3af3e1d1' or plv.pricelevelid = 'c1b02afa-66c3-e711-a94c-000d3af3e1d1')
    left join
        {{ ref('stg_crm_dev3__transactioncurrency') }} as txc
        on plv._transactioncurrencyid_value = txc.transactioncurrencyid
    inner join
        {{ ref('stg_finops_adls_crp__invent_item_group_item') }} as itg
        on lower('TNSF') = lower(itg.itemdataareaid)
            and prd2.productnumber = itg.itemid
            and itg.itemgroupid not in ({{ var("crm_d365_item_group_id_banned") }})
    where
        prd2.productstructure = '1' and prd2.producttypecode = '1'
        and trim(prd2.productnumber) not in (select trim(productid) from {{ ref('int_d365_crm__crm_product_price_list') }})
)

select * from crmpnewpricelist
