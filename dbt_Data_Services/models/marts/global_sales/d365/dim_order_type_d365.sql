with fds_enum_table as (
    select * from {{ ref('stg_d365__fds_enum_table') }}
),

dim_order_type as (
    select distinct

        enumvalue as "Order Type ID",
        enumvaluelabel as "Order Type"

    from fds_enum_table

    where enumid = 5437

    qualify row_number() over (partition by enumvalue order by enumvalue) = 1

)

select * from dim_order_type
