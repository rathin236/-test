with transactions as (

    select * from {{ ref('int_sap_cookeeurope_cpm__gl_transactions') }} where company = 'Morubel NV'

)

select * from transactions