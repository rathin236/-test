select * from {{ ref('dim_d365__companies') }}

union all

select * from {{ ref('dim_gp__companies') }}