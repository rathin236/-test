with d365customer as (
    select distinct
        'EXIST' as status,
        'D365' as source,
        cmt.csdataareaid as company,
        iva.name,
        cmt.csinvoiceaccount as invoiceaccount,
        cmt.cscustgroup as custgroup,
        cmt.blocked as invoicinganddeliveryonhold,
        cmt.cscurrency as currency,
        emp.recid::string as employeeresponsibleid,
        cmt.cspaymtermid as paytermid,
        dpv.street,
        dpv.city,
        dpv.state,
        dpv.county,
        dpv.zipcode,
        dpv.countryregionid as country,
        null as ownertype,
        cmt.csdataareaid as companyuid,
        cmt.csparty as accountuid,
        cmt.cscredmanaccountstatusid as accountstatusuid,
        cmt.cscurrency as currencyuid,
        cmt.cscredmanaccountstatusid as credmanaccountstatusid,
        cmt.credmanstatusreasonid,
        upper(cmt.cscredmanaccountstatusid) as accountstatus,
        trim(cmt.accountnum) as accountnum,
        (concat(trim(emp.empfirstname), ' ', trim(emp.emplastname))) as employeeresponsible,
        concat(
            (case when (cmt.csdataareaid is null or cmt.csdataareaid = '') then 'Company' else '' end),
            (case when (iva.name is null or iva.name = '') then ',Name' else '' end),
            (case when dpl.recid is null then ',PrimaryAddress' else '' end)
        ) as errorlog
    from {{ ref('stg_finops_adls_crp__cust_table') }} as cmt
    left join {{ ref('stg_finops_adls_crp__dir_party_table') }} as iva on cmt.csparty = iva.recid
    left join {{ ref('stg_finops_adls_crp__hcmworker') }} as hcw on cmt.csmaincontactworker = hcw.recid
    left join {{ ref('stg_finops_adls_crp__dir_person_name') }} as emp on hcw.person = emp.person
    left join {{ ref('int_d365_crm__d365InvoiceAddress') }} as dpl on cmt.csparty = dpl.party
    left join
        {{ ref('stg_finops_adls_crp__dir_party_postal_address_view') }} as dpv
        on dpl.recid = dpv.recid and dpv.validfrom::date <= current_date() and dpv.validto::date > current_date()
    where (cmt.csinvoiceaccount = cmt.accountnum or cmt.csinvoiceaccount is null)

)

select * from d365customer
