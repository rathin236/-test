with fds_enum_table as (
    select * from {{ ref('stg_d365__fds_enum_table') }}
),

dim_sales_status_d365 as (
    select

        enumvalue as "Sales Status ID",
        enumvaluelabel as "Sales Status"

    from fds_enum_table

    where enumid = 4408

    qualify row_number() over (partition by enumvalue order by enumvalue) = 1


    order by enumvalue
)

select * from dim_sales_status_d365
