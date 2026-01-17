with price_details as (
    select * from {{ ref('stg_fishtalk__price_table_details') }}
),

price_tbl as (
    select * from {{ ref('stg_fishtalk__price_table') }}
),

insurance as (
    select * from {{ ref('stg_fishtalk__insurance_profile') }}
),

insurance_profile as (
    select * from {{ ref('stg_fishtalk__insurance_profile_assigned') }}
),

price_tbl_details as (
    select
        details.pricetableid,
        details.fromweight,
        details.toweight,
        price.currencyid,
        details.priceperfish,
        details.priceperkg,
        price.tablename,
        price.description,
        price.speciesid
    from price_details as details
    left join price_tbl as price
        on details.pricetableid = price.pricetableid
),

ins_prof as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'ins_prof_as.orgunitid',
            "'CAI'",
            'ins_prof_as.insuranceprofileid',
            'price.fromweight',
            'price.toweight'
        ]) }} as ft_insurance_sk,
        ins_prof_as.orgunitid as site_id,
        ins_prof_as.insuranceprofileid as policy_id,
        try_to_date(
            regexp_substr(
                price.description,
                '\\b(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\\s+[0-9]{1,2}\\s+[0-9]{4}',
                1, 1, 'i'
            ),
            'MON DD YYYY'
        ) as policy_date,
        prof.policynumber as policy_number,
        price.description as policy_description,
        price.currencyid as currency_id,
        price.speciesid as species_id,
        price.fromweight as from_weight,
        price.toweight as to_weight,
        price.priceperfish as price_per_fish,
        price.priceperkg as price_per_kg
    from insurance_profile as ins_prof_as
    left join insurance as prof
        on ins_prof_as.insuranceprofileid = prof.insuranceprofileid
    left join price_tbl_details as price
        on prof.pricetableid = price.pricetableid
)

select *
from ins_prof
