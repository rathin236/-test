with vendors as (

  {{ dbt_utils.union_relations(
      relations=[ ref('dim_gp__vendors'), ref('dim_d365__vendors') ],
      source_column_name=None,
      exclude=['_dbt_source_relation']
  ) }}

),

seed as (

    select
        vendor_id,
        risk_level
    from {{ ref('ap_aging__tns_company_dues') }}

),

terms as (

    select
        vend_terms.*,
        case
            when vend_terms.payment_terms_id like '%NET 25 DAYS%' then 25
            when vend_terms.payment_terms_id like '%DUE ON THE 1ST%' then 21
            when substring(trim(vend_terms.payment_terms_id), 1, 3) = 'NET' then substring(trim(vend_terms.payment_terms_id), 4, 6)
            else 0
        end as vend_terms,
        case
            when exists (
                    select 1
                    from seed as seeds
                    where seeds.vendor_id = vend_terms.vendor_id
                        and vend_terms.company_id = 'TNS'
                ) then 1
            else 0
        end as tns_flag,
        (
            select max(seeds.risk_level)
            from seed as seeds
            where seeds.vendor_id = vend_terms.vendor_id
                and vend_terms.company_id = 'TNS'
        ) as risk_level_flag
    from vendors as vend_terms
)

select *
from terms
