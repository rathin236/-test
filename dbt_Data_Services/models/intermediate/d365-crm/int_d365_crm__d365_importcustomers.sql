with
d365import as (
    select distinct
        'NEW' as status,
        crm.source,
        coalesce(d365.company, '{{ var("crm_d365_d365default_company") }}') as company,
        crm.name,
        ach.cai_d_365_customeraccountnumber as invoiceaccount,
        'AR-TRADE' as custgroup,
        '2' as invoicinganddeliveryonhold,
        'OnHold' as accountstatus,
        crm.currency,
        (case when lower(crm.employeeresponsible) like 's-%' then null else coalesce(hcm.personnelnumber, hcma.personnelnumber) end)
            as employeeresponsibleid,
        crm.employeeresponsible,
        crm.paytermid,
        crm.street,
        crm.city,
        crm.state,
        crm.county,
        crm.zipcode,
        crm.country,
        crm.ownertype,
        crm.companyuid,
        crm.accountuid,
        crm.accountstatusuid,
        crm.currencyuid,
        crm.errorlog,
        d365.credmanstatusreasonid,
        coalesce(crm.accountnum, ach.cai_crmaccountid) as accountnum

    from {{ ref("stg_crm_dev3__opportunity") }} as oph
    inner join
        {{ ref("int_d365_crm__crmcustomer") }} as crm
        on oph._parentaccountid_value = crm.accountuid
    inner join
        {{ ref("stg_crm_dev3__account") }} as ach
        on crm.accountuid = ach.csaccountid
    left join
        {{ ref("int_d365_crm__d365customer") }} as d365
        on coalesce(crm.accountnum, ach.cai_crmaccountid) = d365.accountnum
    left join
        {{ ref("stg_d365_ce__xref_customers") }} as xrf
        on crm.accountuid = xrf.crmcustomeruid
            and xrf.status = 'ACTIVE'
    left join
        {{ ref("stg_crm_dev3__systemuser") }} as usr
        on ach.cs_ownerid_value = usr.systemuserid
    left join
        {{ ref("stg_finops_adls_crp__dir_person_name") }} as emp
        on lower(emp.empfirstname) = lower(usr.firstname)
            and lower(emp.emplastname) = lower(usr.lastname)
    left join
        {{ ref("stg_finops_adls_crp__hcmworker") }} as hcm
        on emp.person = hcm.person
    left join
        {{ ref("stg_d365_ce__user_alias") }} as usa
        on lower(usr.firstname) || ' ' || lower(usr.lastname) = lower(usa.crm)
            and usa.status = 'ACTIVE'
    left join
        {{ ref("stg_finops_adls_crp__dir_person_name") }} as empa
        on lower(empa.empfirstname) || ' ' || lower(empa.emplastname) = lower(usa.d365)
    left join
        {{ ref("stg_finops_adls_crp__hcmworker") }} as hcma
        on empa.person = hcma.person
    where
        oph.statecode = 0
        and oph.stepname = '3-Evaluate'
        and oph._originatingleadid_value is not null
        and ach.cai_d_365_customeraccountnumber is null
        and (xrf.d365customerid is null or xrf.status = 'ACTIVE')
        and ach.csstatecode = '0'
        and d365.status is null and ach.createdon > '{{ var("crm_d365_d365import_created_on") }}'

)

select *
from d365import
