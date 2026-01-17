with cust_external_item as (
    {{
        dbt_utils.union_relations(
            relations = [ref('int_cust_external_item__d365'),
                        ref('int_cust_external_item__coolearth')]
        )
    }}
),

final as (
    select
        sourcesystem,
        "Company",
        "Item ID",
        "Customer Relation or Address",
        "Customer Name",
        "Customer External Item ID",
        "Customer External Item Description",
        sk_item_global,
        cust_external_item_pk
    from cust_external_item
)

select *
from final
