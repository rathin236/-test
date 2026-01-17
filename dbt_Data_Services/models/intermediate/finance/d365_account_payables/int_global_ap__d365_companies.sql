with company as (
    select {{ trim_columns_int('stg_d365__data_area') }}
    from {{ ref('stg_d365__data_area') }}
    where fno_id = 'TNSF'
)

select
    cast(id as varchar) as companyid,
    fno_id as interid,
    '' as city,
    '' as state,
    name as company_name
from company
