with source as (

    select * from {{ source('fishtalk', 'publictranslations') }}

),

renamed as (

    select
        languageid,
        textid::number,
        text,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
