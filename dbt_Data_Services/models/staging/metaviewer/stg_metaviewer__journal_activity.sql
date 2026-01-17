with

source as (

    select * from {{ source('metaviewer_dbo', 'journalactivity') }}

),

renamed as (

    select
        activityid,
        description,
        activityname,
        appdata,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
