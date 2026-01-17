with dim_attribute_om_business_unit as (
    select * from {{ ref('int_d365__dim_attribute_om_business_unit') }}
),

dim_financial_division as (
    select

        name as "Financial Division",
        value_ as "Financial Division ID"

    from dim_attribute_om_business_unit

    qualify row_number() over (partition by value_ order by value_) = 1

    order by value_
)

select * from dim_financial_division
