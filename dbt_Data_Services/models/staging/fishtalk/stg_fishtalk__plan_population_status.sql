with source as (

    select * from {{ source('fishtalk', 'planpopulationstatus') }}

),

renamed as (

    select
        actualdate,
        accmortalitycount,
        accculledcount,
        individcount,
        accdiscardcount,
        accfishdays,
        accharvestcount,
        accharvestbiomass,
        accsalebiomass,
        actual,
        biomass,
        accinputcount,
        accsalecount,
        accculledbiomass,
        accdiscardbiomass,
        accmortalitybiomass,
        cv,
        accinputbiomass,
        accnetharvestbiomass,
        _fivetran_deleted,
        _fivetran_synced,
        trim(planpopulationid) as planpopulationid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
