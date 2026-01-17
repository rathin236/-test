with
importdata as (  -- cte to compare d365product against crmproduct, and flag the records that needs to be created as new or updated
    select distinct
        coalesce(d365.productid, crm.productid) as productid,
        coalesce(d365.productdesc, crm.productdesc) as productdesc,
        coalesce(d365.companyid, crm.companyid) as companyid,
        case
            when (d365.productid = crm.productid)
                then
                    (
                        case
                            when
                                d365.productdesc = crm.productdesc
                                and d365.statusuid = 'IsActiveForPlanning'
                                and crm.statusuid = '{{ var('crm_d365_statusuid_active_for_planning') }}'
                                and crm.company = d365.company
                                then 'EXIST'
                            when
                                crm.parentproductid_value is not null
                                and crm.statusuid = '{{ var('crm_d365_statusuid_inactive') }}'
                                then 'EXIST'
                            when
                                d365.productdesc = crm.productdesc or (d365.productdesc is null and crm.productdesc is null)
                                and d365.statusuid = 'IsActiveForPlanning'
                                and crm.statusuid = '{{ var('crm_d365_statusuid_active_for_planning') }}'
                                and (array_except(split(d365.company, ';'), split(crm.company, ';')) = [])
                                then 'EXIST'

                            else 'UPDATE'
                        end
                    )
            else (case when d365.status = 'EXIST' then 'NEW' else d365.status end)
        end as status,
        coalesce(d365.source, crm.source) as source,
        d365.company as d365company,
        crm.company as crmcompany,
        case
            when
                d365.company = crm.company
                then d365.company
            when crm.company is null
                then d365.company
            else
                array_to_string(array_cat(array_except(split(d365.company, ';'), split(crm.company, ';')), split(crm.company, ';')), ';')
        end
            as company,
        {# coalesce(d365.company, crm.company) as company, #}
        coalesce(d365.productstructure, crm.productstructure) as productstructure,
        coalesce(d365.producttype, crm.producttype) as producttype,
        upper(coalesce(d365.unitgroup, crm.unitgroup)) as unitgroup,
        coalesce(d365.unit, crm.unit) as unit,
        coalesce(d365.gpproductid, crm.gpproductid) as gpproductid,
        coalesce(d365.d365productid, crm.d365productid) as d365productid,
        coalesce(d365.crmproductid, crm.crmproductid) as crmproductid,
        coalesce(crm.uomscheduleid, pug.uomscheduleid) as uomscheduleid,
        coalesce(crm.uomid, pug.uomid) as uomid,
        (
            case
                when
                    d365.statusuid = 'IsActiveForPlanning'
                    and (
                        crm.statusuid not in ('{{ var('crm_d365_statusuid_draft') }}')
                        or (
                            crm.statusuid = '{{ var('crm_d365_statusuid_inactive') }}'
                            and crm.parentproductid_value is null
                        )
                    )
                    then '{{ var('crm_d365_statusuid_active_for_planning') }}'
                else coalesce(crm.statusuid, '{{ var('crm_d365_statusuid_active_for_planning') }}')
            end
        ) as statusuid,
        coalesce(crm.parentproductid_value, d365.parentproductid_value) as parentproductid_value

    from {{ ref("int_d365_crm__d365product") }} as d365
    left join
        {{ ref("int_d365_crm__crmproduct") }} as crm
        on
            d365.productid = crm.productid
    left join
        {{ ref("d365_crm__v_product_unit_groups") }} as pug
        on d365.productid = pug.productid and pug.source = 'CRM'
    inner join
        {{ ref('stg_finops_adls_crp__invent_item_group_item') }} as itg
        on lower(d365.company) = lower(itg.itemdataareaid)
            and coalesce(d365.productid, crm.productid) = itg.itemid
            and itg.itemgroupid not in ({{ var("crm_d365_item_group_id_banned") }})
    where
        d365.statusuid = 'IsActiveForPlanning'
        and (
            case
                when (d365.productid = crm.productid)
                    then
                        (
                            case
                                when d365.productdesc = crm.productdesc
                                    and d365.statusuid = 'IsActiveForPlanning'
                                    and crm.statusuid = '{{ var('crm_d365_statusuid_active_for_planning') }}'
                                    and d365.company = crm.company
                                    then 'EXIST'
                                when
                                    crm.parentproductid_value is not null
                                    and crm.statusuid = '{{ var('crm_d365_statusuid_inactive') }}'
                                    then 'EXIST'
                                when
                                    d365.productdesc = crm.productdesc or (d365.productdesc is null and crm.productdesc is null)
                                    and d365.statusuid = 'IsActiveForPlanning'
                                    and crm.statusuid = '{{ var('crm_d365_statusuid_active_for_planning') }}'
                                    {# and  d365.company = crm.company #}
                                    and array_except(split(d365.company, ';'), split(crm.company, ';')) = []
                                    {# and  d365.company like crm.company #}
                                    then 'EXIST'
                                else 'UPDATE'
                            end
                        )
                else
                    (
                        case
                            when d365.status = 'EXIST'
                                then 'NEW'
                            else d365.status
                        end
                    )
            end
        )
        not in (
            'EXIST',
            'ERROR'
        )
)

select *
from importdata
