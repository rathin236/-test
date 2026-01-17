with po_hist as (
    select * from {{ ref('int_ifs__fct_po_inventory') }}

)

select * from po_hist
