with crmcustomer as (
    select distinct
        'EXIST' as status,
        'CRM' as source,
        cmp.activevalue as company,
        ach.name,
        ach.cscustomertypecode as custgroup,
        null as invoicinganddeliveryonhold,
        txc.isocurrencycode as currency,
        ach.cs_ownerid_value as employeeresponsibleid,
        cast((coalesce(concat(trim(usr.firstname), ' ', trim(usr.lastname)), trim(tem.name))) as string) as employeeresponsible,
        ach.cspaymenttermscode as paytermid,
        ach.address_1_line_1 as street,
        ach.address_1_city as city,
        ach.address_1_stateorprovince as state,
        null as county,
        ach.address_1_postalcode as zipcode,
        ach.address_1_country as country,
        ach.cscai_sellto as companyuid,
        ach.csaccountid as accountuid,
        ach.csstatecode as accountstatusuid,
        ach.cs_transactioncurrencyid_value as currencyuid,
        null as errorlog,
        null as credmanstatusreasonid,
        upper(stc.activevalue) as accountstatus,
        trim(coalesce(ach.cai_d_365_customeraccountnumber, xrf.d365customerid, ach.cai_crmaccountid, ach.accountnumber)) as accountnum,
        trim(coalesce(ach.cai_d_365_customeraccountnumber, ach.accountnumber)) as invoiceaccount,
        (case when (usr.firstname is not null or usr.lastname is not null) then 'USER'
            else (case when tem.name is not null then 'TEAM' else 'ERROR' end)
        end) as ownertype

    from {{ ref('stg_crm_dev3__account') }} as ach
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as cmp
        on cmp.attributevalue = (case when ach.cscai_sellto like '%809090001%' then '809090001' else '809090000' end)
            and cmp.attributename = 'cai_sellto'
    left join
        {{ ref('stg_crm_dev3__opportunity') }} as oph
        on ach.csaccountid = oph._parentaccountid_value and oph.statecode = 0 and oph.stepname = '3-Evaluate'
    left join {{ ref('stg_crm_dev3__transactioncurrency') }} as txc on ach.cs_transactioncurrencyid_value = txc.transactioncurrencyid
    left join {{ ref('stg_crm_dev3__systemuser') }} as usr on ach.cs_ownerid_value = usr.systemuserid
    left join {{ ref('stg_crm_dev3__team') }} as tem on ach.cs_ownerid_value = tem.teamid
    left join
        {{ ref('stg_crm_dev3__stringmap') }} as stc
        on ach.csstatecode = stc.attributevalue and stc.attributename = 'statecode' and stc.objecttypecode = 'account'
    left join {{ ref('stg_d365_ce__xref_customers') }} as xrf on ach.csaccountid = xrf.crmcustomeruid

)

select * from crmcustomer
