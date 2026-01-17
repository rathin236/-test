with
crmimport as (
    select distinct
        cast(coalesce(d365.company, crm.company) as string) as company,
        cast(
            (
                case
                    when d365.accountstatus = 'INACTIVE'
                        then '{{ var('crm_d365_statusuid_inactive') }}'
                    else
                        (
                            case
                                when
                                    d365.accountstatus = 'ONHOLD'
                                    and d365.credmanstatusreasonid != 'New'
                                    and d365.invoicinganddeliveryonhold = 2
                                    then '{{ var('crm_d365_statusuid_inactive') }}'
                                else '{{ var('crm_d365_statusuid_active_for_planning') }}'
                            end
                        )
                end
            ) as string
        ) as accountstatusuid,
        cast(
            coalesce(
                'systemusers(' || usr.systemuserid || ')',
                'teams(' || tem.teamid || ')',
                '{{ var("crm_d365_customer_default_team") }}'
            ) as string
        ) as employeeresponsibleid,
        (
            case
                when
                    crm.accountnum is null
                    and crm2.company is null
                    and d365.accountstatus = 'ONHOLD'
                    and d365.credmanstatusreasonid = 'New'
                    and d365.invoicinganddeliveryonhold = 2
                    then 'EXIST'
                else
                    (
                        case
                            when (crm.accountnum is null and crm2.company is null)
                                then 'NEW'
                            else
                                (
                                    case
                                        when
                                            (
                                                d365.accountnum = crm.accountnum
                                                and (

                                                    d365.name != crm.name
                                                    or d365.street
                                                    != coalesce(crm.street, crm2.street)
                                                    or d365.city
                                                    != coalesce(crm.city, crm2.city)
                                                    or d365.state
                                                    != coalesce(crm.state, crm2.state)
                                                    or d365.county
                                                    != coalesce(crm.county, crm2.county)
                                                    or d365.zipcode != coalesce(
                                                        crm.zipcode, crm2.zipcode
                                                    )
                                                    or d365.country != coalesce(
                                                        crm.country, crm2.country
                                                    )
                                                    or
                                                    (
                                                        d365.accountstatus != crm.accountstatus and d365.accountstatus != 'ONHOLD'
                                                        and crm.accountstatus != 'ACTIVE'
                                                    )
                                                )
                                            )
                                            then 'UPDATE'
                                        else 'EXIST'
                                    end
                                )
                        end
                    )
            end
        ) as status,
        coalesce(d365.source, crm.source) as source,
        coalesce(d365.accountnum, crm.accountnum) as accountnum,
        coalesce(d365.name, crm.name) as cusname,
        coalesce(d365.invoiceaccount, crm.invoiceaccount) as invoiceaccount,
        coalesce(d365.custgroup, crm.custgroup) as custgroup,
        coalesce(
            d365.invoicinganddeliveryonhold, crm.invoicinganddeliveryonhold
        ) as invoicinganddeliveryonhold,
        coalesce(d365.accountstatus, crm.accountstatus) as accountstatus,

        coalesce(d365.currency, crm.currency) as currency,
        coalesce(
            als.crm, d365.employeeresponsible, crm.employeeresponsible
        ) as employeeresponsible,
        coalesce(d365.paytermid, crm.paytermid) as paytermid,
        coalesce(d365.street, crm.street) as street,
        coalesce(d365.city, crm.city) as city,
        coalesce(d365.state, crm.state) as state,
        coalesce(d365.county, crm.county) as county,
        coalesce(d365.zipcode, crm.zipcode) as zipcode,
        coalesce(d365.country, crm.country) as country,
        coalesce(crm.ownertype, d365.ownertype) as ownertype,
        (
            case
                when d365.company != crm.company
                    then cast(coalesce(cmp.attributevalue, '{{ var('crm_d365_customer_default_company_num') }}') as string)
                else
                    (
                        case
                            when
                                coalesce(crm.companyuid, crm2.companyuid)
                                like '%{{ var('crm_d365_customer_default_company_num') }}%'
                                then coalesce(crm.companyuid, crm2.companyuid)
                            else
                                cast(
                                    coalesce(
                                        concat(
                                            coalesce(
                                                crm.companyuid, crm2.companyuid
                                            ),
                                            ',',
                                            cmp.attributevalue
                                        ),
                                        '{{ var('crm_d365_customer_default_company_num') }}'
                                    ) as string
                                )
                        end
                    )
            end
        ) as companyuid,
        coalesce(crm.accountuid, crm2.accountuid) as accountuid,
        coalesce(crm.currencyuid, cur.transactioncurrencyid) as currencyuid,
        coalesce(d365.errorlog, crm.errorlog) as errorlog,
        coalesce(
            d365.credmanstatusreasonid, crm.credmanstatusreasonid
        ) as credmanstatusreasonid
    from {{ ref("int_d365_crm__d365customer") }} as d365
    left join
        {{ ref("int_d365_crm__crmcustomer") }} as crm
        on d365.company = crm.company
            and d365.accountnum = crm.accountnum
    left join
        {{ ref("int_d365_crm__crmcustomer") }} as crm2
        on d365.company != crm2.company
            and crm2.company is not null
            and d365.accountnum = crm2.accountnum
    left join
        {{ ref("stg_crm_dev3__stringmap") }} as cmp
        on d365.company = cmp.activevalue
            and cmp.attributename = 'cai_sellto'
            and cmp.objecttypecode = 'account'
    left join
        {{ ref("stg_d365_ce__user_alias") }} as als
        on d365.company = als.company
            and d365.employeeresponsible = als.d365
    left join
        {{ ref("stg_crm_dev3__systemuser") }} as usr
        on lower(concat(trim(usr.firstname), ' ', trim(usr.lastname)))
            = coalesce(lower(als.crm), lower(d365.employeeresponsible))
    left join
        {{ ref("stg_crm_dev3__team") }} as tem
        on lower(trim(tem.name))
            = coalesce(lower(als.crm), lower(d365.employeeresponsible))
    left join
        {{ ref("stg_crm_dev3__transactioncurrency") }} as cur
        on coalesce(d365.currency, crm.currency) = cur.isocurrencycode
    left join
        staging_dev.d365_ce.xref_customers as xrf
        on xrf.crmcustomeruid = coalesce(crm2.accountnum, crm.accountnum)
            and xrf.status = 'ACTIVE'
    where
        (
            case
                when (crm.accountnum is null and d365.credmanstatusreasonid = 'NEW')
                    then 'EXIST'
                when (crm.accountnum is null and crm2.company is null)
                    then 'NEW'
                else
                    (
                        case
                            when
                                (
                                    d365.accountnum = crm.accountnum
                                    and d365.name = crm.name
                                    and d365.street
                                    = coalesce(crm.street, crm2.street)
                                    and d365.city = coalesce(crm.city, crm2.city)
                                    and d365.state = coalesce(crm.state, crm2.state)
                                    and d365.county
                                    = coalesce(crm.county, crm2.county)
                                    and d365.zipcode
                                    = coalesce(crm.zipcode, crm2.zipcode)
                                    and d365.country
                                    = coalesce(crm.country, crm2.country)
                                )
                                then 'EXIST'
                            when
                                (
                                    d365.accountnum = crm.accountnum
                                    and d365.accountstatus = 'ONHOLD'
                                    and crm.accountstatus = 'INACTIVE'
                                    and d365.credmanstatusreasonid = 'Bad'

                                )
                                then 'EXIST'
                            else 'UPDATE'
                        end
                    )
            end
        )
        in ('NEW', 'UPDATE')
        and (xrf.crmcustomeruid is null or xrf.status = 'ACTIVE')
        and d365.invoiceaccount is not null

)

select *
from crmimport
