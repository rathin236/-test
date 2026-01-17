with company_tab as (
    select * from {{ ref('stg_ifs__company_tab') }}

)

select
    company,
    party,
    party_type,
    country,
    from_template_id,
    creation_date,
    name as company_name

from company_tab
