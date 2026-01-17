with crmproduct as ( --cte to get all crm active/under revision products
    select distinct
        'EXIST' as status,
        'CRM' as source,
        crm.productstructure,
        crm.producttypecode as producttype,
        crm.productnumber as productid,
        crm.name as productdesc,
        crm.cai_gpproductid as gpproductid,
        crm.cai_d_365_productid as d365productid,
        crm.productid as crmproductid,
        uoms.uomscheduleid,
        uom.uomid,
        crm.cai_company as companyid,
        crm.prstatecode as statusuid,
        prd._parentproductid_value as parentproductid_value,
        upper(uoms.name) as unitgroup,
        upper(uom.unitname) as unit,

        (
            case
                when crm.cai_company is null then null
                else
                    concat(
                        cmp1.activevalue,
                        (case when cmp2.activevalue is null then '' else concat(';', cmp2.activevalue) end),
                        (case when cmp3.activevalue is null then '' else concat(';', cmp3.activevalue) end),
                        (case when cmp4.activevalue is null then '' else concat(';', cmp4.activevalue) end),
                        (case when cmp5.activevalue is null then '' else concat(';', cmp5.activevalue) end)
                    )
            end
        ) as company

    from {{ ref('stg_crm_dev3__product') }} as crm
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp1
        on cmp1.attributevalue = split_part(crm.cai_company, ',', 1)
            and cmp1.attributename = 'cai_company'
            and cmp1.objecttypecode = 'product'
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp2
        on cmp2.attributevalue = split_part(crm.cai_company, ',', 2)
            and cmp2.attributename = 'cai_company'
            and cmp2.objecttypecode = 'product'
            and crm.cai_company is not null
            and crm.cai_company like '%,%'
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp3
        on cmp3.attributevalue = split_part(crm.cai_company, ',', 3)
            and cmp3.attributename = 'cai_company'
            and cmp3.objecttypecode = 'product'
            and crm.cai_company is not null
            and crm.cai_company like '%,%'
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp4
        on cmp4.attributevalue = split_part(crm.cai_company, ',', 4)
            and cmp4.attributename = 'cai_company'
            and cmp4.objecttypecode = 'product'
            and crm.cai_company is not null
            and crm.cai_company like '%,%'
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp5
        on cmp5.attributevalue = split_part(crm.cai_company, ',', 5)
            and cmp5.attributename = 'cai_company'
            and cmp5.objecttypecode = 'product'
            and crm.cai_company is not null
            and crm.cai_company like '%,%'
    left join
        {{ ref('stg_crm_dev3__product') }} as prd
        on crm.productnumber = prd.productnumber
    inner join
        {{ ref('stg_crm_dev3__uomschedule') }} as uoms
        on crm._defaultuomscheduleid_value = uoms.uomscheduleid
    inner join {{ ref('stg_crm_dev3__uom') }} as uom
        on crm._defaultuomid_value = uom.uomid
    where crm.productstructure = '1'
        and crm.producttypecode = '1'
)

select * from crmproduct
