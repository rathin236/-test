with company as (
    select {{ trim_columns_int('stg_gp__company_name') }} from {{ ref('stg_gp__company_name') }}
),

vendor as ( 
    select {{ trim_columns_int('stg_gp_tnsc__pm00200') }} from {{ ref('stg_gp_tnsc__pm00200') }}
    where vndclsid is not null
),

vendor_master as (
    select
        (select interid from company where trim(interid) = 'TNSC') as company_id,
        vendorid as vendor_id,
        vendname as vendor_name,
        vndclsid as vendor_class,
        creatddt as created_date,
        userdef1,
        pymtrmid as payment_terms_id,
        address1 as address_1,
        address2 as address_2,
        address3 as address_3,
        city,
        state,
        zipcode as zip_code,
        country,
        curncyid as currency_id,
        txidnmbr as tax_id,
        case
            when vendstts = 1 then 'Active'
            when vendstts = 2 then 'Inactive'
            when vendstts = 3 then 'Temporary'
        end as vendor_status,
        case
            when ten99type = 1 then 'Not a 1099 Vendor'
            when ten99type = 2 then 'Dividend'
            when ten99type = 3 then 'Interest'
            when ten99type = 4 then 'Miscellaneous'
        end as ten99_type,
        case when userdef1 like '%DNB%' then 'SCF Vendor'
             when substring(vndclsid, 1, 2) = 'TR' then 'Trade'
             when substring(vndclsid, 1, 2) = 'IC' then 'Inter Company'
             when substring(vndclsid, 1, 2) = 'RP' then 'Related Party'
        end as vendor_type,
        md5(concat(trim(upper(company_id)), trim(upper(vendor_id)))) as sk_vendor_global
    from
        vendor
)

select * from vendor_master