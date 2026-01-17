with
tns_po_headers as (
    select
        *,
        ponumber || cmpanyid || vendor_id as ereq_key
    from {{ ref("int_tns__purchase_order_header") }}
),

kcs_po_headers as (
    select
        *,
        ponumber || cmpanyid || vendor_id as ereq_key
    from {{ ref("int_kcs__purchase_order_header") }}
),

cpqln_po_headers as (
    select
        *,
        ponumber || cmpanyid || vendor_id as ereq_key
    from {{ ref("int_cpqln__purchase_order_header") }}
),

all_po_headers as (
    select *
    from tns_po_headers
    union all
    select *
    from kcs_po_headers
    union all
    select *
    from cpqln_po_headers
)

select *
from all_po_headers
