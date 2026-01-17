with

source as (

    select * from {{ source('kontali', 'kontali_curve_taxonomy') }}

),

renamed as (

    select
        curvename,
        taxonomy_detail,
        lastupdatedate,
        executionid

    from source

)

select * from renamed
