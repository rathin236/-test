with fds_enum_table as (
    select * from {{ ref('stg_d365__fds_enum_table') }}
),

dim_sales_type as (
    select distinct

        enumvalue as "Sales Type ID",
        enumvaluelabel as "Sales Type"

    from fds_enum_table

    where enumid = 5437

    qualify row_number() over (partition by enumvalue order by enumvalue) = 1

    order by enumvalue

)

select * from dim_sales_type
