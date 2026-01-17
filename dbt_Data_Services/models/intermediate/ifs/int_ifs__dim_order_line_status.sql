with order_line as (
    select * from {{ ref('stg_ifs__purchase_order_line_hist_tab') }}

)

select hist_objstate as status
from order_line
group by 1
