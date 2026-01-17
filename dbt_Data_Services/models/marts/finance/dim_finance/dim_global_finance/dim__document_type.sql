select * from {{ ref('dim_d365__document_type') }}

union all

select * from {{ ref('dim_gp__document_type') }}