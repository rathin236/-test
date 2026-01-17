with company as (
    select {{ trim_columns_int('stg_d365__data_area') }}
    from {{ ref('stg_d365__data_area') }}
    where fno_id = 'TNSF'
),

vendor as (
    select {{ trim_columns_int('stg_d365__vend_table') }} 
    from {{ ref('stg_d365__vend_table') }}
),

vendor_name as (
    select {{ trim_columns_int('int_d365__vendor_account_name') }} 
    from {{ ref('int_d365__vendor_account_name') }}
),

dir_party_address as (
    select {{ trim_columns_int('int_d365__dir_party_postal_address') }} 
    from {{ ref('int_d365__dir_party_postal_address') }}
),

vendor_master as (
    select
        (select fno_id from company where trim(fno_id) = 'TNSF') as company_id,
        vend.accountnum as vendor_id,
        vendor_name.name_description as vendor_name,
        concat(substring(vend.vendgroup, 4,2), vend.currency) as vendor_class,
        vend.createddatetime as created_date,
        vend.lineofbusinessid as userdef1,
        vend.paymtermid as payment_terms_id,
        dpt.address as address_1,
        dpt.location_name as address_2,
        '' as address_3,
        dpt.city,
        dpt.state,
        dpt.zipcode as zip_code,
        dpt.CountryRegionId as country,
        vend.currency as currency_id,
        vend.taxgroup as tax_id,
        case
            when vend.blocked = 0 then 'Active'
            when vend.blocked = 2 then 'Temporary' --blocked for POs
            when vend.blocked = 3 then 'Inactive' --blocked for all transactions
        end as vendor_status,
        case
            when vend.tax_1099_fields = 0 then 'Not a 1099 Vendor'
            when vend.tax_1099_fields = '5637144590' then 'Dividend'
            when vend.tax_1099_fields = '5637144576' then 'Miscellaneous'
        end as ten99_type,
        case
                when vend.lineofbusinessid like '%DNB%' then 'SCF Vendor' 
                when vend.vendgroup like '%TR%' then 'Trade'
                when vend.vendgroup in  ('AP-IC', 'AP-ID') then 'Inter Company'
                when vend.vendgroup like '%RP%' then 'Related Party'
        end as vendor_type,
        md5(concat(trim(upper(company_id)), trim(upper(vendor_id)), 'D365')) as sk_vendor_global
    from
        vendor vend

        inner join dir_party_address dpt 
            on vend.party = dpt.party
        
        left join vendor_name
            on vend.accountnum = vendor_name.vendor_id
        
         qualify row_number() over (partition by sk_vendor_global, vendor_id, company_id order by created_date desc) = 1
)

select * from vendor_master
-- where vendor_id = 'V1000538'
-- where vendor_type = 'Inter Company'