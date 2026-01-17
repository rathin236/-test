with company as (
    select {{ trim_columns_int('stg_gp__company_name') }}
    from {{ ref('stg_gp__company_name') }}
),

vendor as (
    select {{ trim_columns_int('stg_gp_cpqln__pm00200') }}
    from {{ ref('stg_gp_cpqln__pm00200') }}
),

vendor_master as (
    select
        vendor.vendorid as vendor_id,
        vendor.vendname as vendor_name,
        vendor.vndclsid as vendor_class,
        vendor.creatddt as created_date,
        vendor.userdef1,
        vendor.pymtrmid as payment_terms_id,
        vendor.address1 as address_1,
        vendor.address2 as address_2,
        vendor.address3 as address_3,
        vendor.city,
        vendor.state,
        vendor.zipcode as zip_code,
        vendor.country,
        vendor.curncyid as currency_id,
        vendor.txidnmbr as tax_id,
        company.interid as company_id,
        case vendor.vendstts
            when 1 then 'Active'
            when 2 then 'Inactive'
            when 3 then 'Temporary'
        end as vendor_status,
        case vendor.ten99type
            when 1 then 'Not a 1099 Vendor'
            when 2 then 'Dividend'
            when 3 then 'Interest'
            when 4 then 'Miscellaneous'
        end as ten99_type,
        case
            when vendor.userdef1 in ('RELATED PARTY', 'R/P', 'RELATEDPARTY') then 'Related Party'
            when vendor.userdef1 in ('IC', 'INTERCOMPANY', 'INTER COMPANY', 'I/C') then 'Inter Company'
            when vendor.userdef1 like '%DNB%' then 'SCF Vendor'
            else 'Trade'
        end as vendor_type,
        md5(concat(trim(upper(company.interid)), trim(upper(vendor.vendorid)))) as sk_vendor_global
    from vendor
    -- restrict to CPQLN once here; avoids scalar subqueries and RF02
    inner join company
        on trim(company.interid) = 'CPQLN'
)

select *
from vendor_master
