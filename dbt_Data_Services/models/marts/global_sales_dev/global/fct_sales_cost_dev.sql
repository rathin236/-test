select * from {{ ref('fct_sales_cost') }}
where "Create Date" >= dateadd(month, -6, getdate())
    and "Create Date" is not null
