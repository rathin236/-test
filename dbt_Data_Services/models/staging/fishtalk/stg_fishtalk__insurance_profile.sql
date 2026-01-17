with source as (

    select {{ convert_columns('fishtalk', 'insuranceprofile') }}
    from {{ source('fishtalk', 'insuranceprofile') }}

),

renamed as (

    select
        insuranceprofileid,
        basepremium,
        insurancecompany,
        policynumber,
        diseasepremium,
        maxavgweightpremiumdisease,
        insuranceprofilename,
        pricetableid,
        speciesid,
        accidentpremium,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
