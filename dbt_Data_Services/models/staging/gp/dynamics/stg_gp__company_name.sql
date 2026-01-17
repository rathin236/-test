with source as (

    select * from {{ source('gp', 'sy01500') }}

),

renamed as (

    select
        cast(cmpanyid as varchar) as cmpanyid,
        interid,
        city,
        state,
        cmpnynam as company_name

    from source

)

select * from renamed
