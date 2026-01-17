with

source as (

    select * from {{ source('innova_fbdag', 'qcs_dataagg') }}

),

renamed as (

    select
        id,
        material,
        sprperiod,
        lot,
        nregs,
        batch,
        activeseconds,
        destination,
        rtype,
        laneid,
        defectclass,
        scanningresult,
        modtime,
        station,
        prperiod,
        weight,
        shift,
        device,
        nregstriggerlimit,
        po,
        regtime,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
