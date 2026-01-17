with

source as (

    select {{ convert_columns('fishtalk', 'organisationunit') }}
    from {{ source('fishtalk', 'organisationunit') }}

),

renamed as (

    select
        native,
        timeoffset,
        active,
        name,
        changecalculationminutesafter,
        changecalculationminutesbefore,
        sortindex,
        heightcorrection,
        tidepredictionlocationid,
        nativedatabaseid,
        farmid,
        _fivetran_deleted,
        _fivetran_synced,
        trim(locationid) as locationid,
        trim(groupid) as groupid,
        trim(orgunittypeid) as orgunittypeid,
        trim(orgunitid) as orgunitid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
