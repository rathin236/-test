with gl_transactions as (

    select * from {{ ref('int_cpm_sladegorton__gl_transactions') }}

)

select * from gl_transactions