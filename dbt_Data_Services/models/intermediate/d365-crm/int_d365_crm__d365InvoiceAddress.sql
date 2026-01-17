with d365invoiceaddress as (
    select distinct
        party,
        first_value(recid) over (partition by party order by assignmentdate desc) as recid
    from {{ ref('stg_finops_adls_crp__dir_party_location') }}
    where isroleinvoice = '1' and postaladdressroles like '%Invoice%' and _fivetran_deleted = false
)

select * from d365invoiceaddress
