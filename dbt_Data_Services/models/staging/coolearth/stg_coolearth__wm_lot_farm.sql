with source as (

    select * from {{ source('coolearth', 'wmlotfarm') }}

),

renamed as (

    select
        dbserverdatetime,
        farm,
        cage,
        lot,
        certifications,
        wmlotfarm_id,
        _fivetran_deleted,
        _fivetran_synced,
        trim(company) as company

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
