with fds_enum_table as (
    select * from {{ ref('stg_d365__fds_enum_table') }}
),

final as (
    select

        enumvalue as "Order Status ID",
        enumvaluelabel as "Order Status"

    from fds_enum_table

    where enumid = 3815

    qualify row_number() over (partition by enumvalue order by enumvalue) = 1

    order by enumvalue

)

select * from final
