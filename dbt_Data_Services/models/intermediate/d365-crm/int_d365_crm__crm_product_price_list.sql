with crmpricelist as ( --cte to get all crm product price list
    select distinct
        'CRM' as source,
        pdl.prodnumber as productid,
        plv.name as pricelist,
        plv.pricelevelid as pricelistid,
        uom.unitname as unit,
        pdl.amount_base as amount,
        txc.currencyname as currency,
        'No Control' as quantsellopt,
        'None' as roundpolicy,
        prd.productid as productuid,
        prd._defaultuomscheduleid_value as uomscheduleid,
        iff(plv.pricelevelid is null, 'NEW', 'EXIST') as status,
        (
            case
                when prd.cai_company is null then null else
                    concat(
                        cmp1.activevalue,
                        (case when cmp2.activevalue is null then '' else concat(';', cmp2.activevalue) end),
                        (case when cmp3.activevalue is null then '' else concat(';', cmp3.activevalue) end),
                        (case when cmp4.activevalue is null then '' else concat(';', cmp4.activevalue) end),
                        (case when cmp5.activevalue is null then '' else concat(';', cmp5.activevalue) end)
                    )
            end
        ) as company
    from
        {{ ref('stg_crm_dev3__productpricelevel') }} as pdl
    left join {{ ref('stg_crm_dev3__pricelevel') }} as plv on pdl._pricelevelid_value = plv.pricelevelid
    left join {{ ref('stg_crm_dev3__uom') }} as uom on pdl._uomid_value = uom.uomid
    left join
        {{ ref('stg_crm_dev3__transactioncurrency') }} as txc
        on pdl._transactioncurrencyid_value = txc.transactioncurrencyid
    left join {{ ref('stg_crm_dev3__product') }} as prd on pdl._productid_value = prd.productid
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp1
        on cast(cmp1.attributevalue as string) = cast(split_part(prd.cai_company, ',', 1) as string)
            and cmp1.attributename = 'cai_company'
            and cmp1.objecttypecode = 'product'

    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp2
        on cast(cmp2.attributevalue as string) = cast(split_part(prd.cai_company, ',', 2) as string)
            and cmp2.attributename = 'cai_company'
            and cmp2.objecttypecode = 'product'
            and prd.cai_company is not null
            and prd.cai_company like '%,%'

    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp3
        on cast(cmp3.attributevalue as string) = cast(split_part(prd.cai_company, ',', 3) as string)
            and cmp3.attributename = 'cai_company'
            and cmp3.objecttypecode = 'product'
            and prd.cai_company is not null
            and prd.cai_company like '%,%'

    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp4
        on cast(cmp4.attributevalue as string) = cast(split_part(prd.cai_company, ',', 4) as string)
            and cmp4.attributename = 'cai_company'
            and cmp4.objecttypecode = 'product'
            and prd.cai_company is not null
            and prd.cai_company like '%,%'

    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp5
        on cast(cmp5.attributevalue as string) = cast(split_part(prd.cai_company, ',', 5) as string)
            and cmp5.attributename = 'cai_company'
            and cmp5.objecttypecode = 'product'
            and prd.cai_company is not null
            and prd.cai_company like '%,%'

    order by pdl.prodnumber

)

select * from crmpricelist
