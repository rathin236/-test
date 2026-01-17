with source as (

    select * from {{ source('fishtalk', 'populations') }}

),

renamed as (

    select
        populationname,
        projectnumber,
        inputyear,
        runningnumber,
        starttime,
        fishgroupnumberislocked,
        species,
        endtime,
        intermediate,
        _fivetran_deleted,
        _fivetran_synced,
        trim(containerid) as containerid,
        trim(populationid) as populationid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
