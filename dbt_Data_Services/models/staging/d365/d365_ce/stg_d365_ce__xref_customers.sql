with

source as (

    select * from {{ source('d365_ce', 'xref_customers') }}

),

renamed as (

    select
        d365customerid,
        d365customername,
        crmcustomerid,
        crmcustomername,
        crmcustomeruid,
        status

    from source

)

select * from renamed
