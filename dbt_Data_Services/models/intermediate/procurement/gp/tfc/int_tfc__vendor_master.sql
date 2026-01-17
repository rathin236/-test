with vendor_master as (
    select
        'TFC' as company,
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
        company || vendor_id as vendor_key
    from
        {{ ref('stg_gp_tfc__pm00200') }}
)

select * from vendor_master
