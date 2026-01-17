with transactions as (

    select * from {{ ref('int_sap_cookeeurope_cpm__gl_transactions') }} where company = 'SHORE NV'

)

select * from transactions