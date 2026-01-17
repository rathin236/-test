with

source as (

    select * from {{ source('metaviewer_dbo', 'journal') }}

),

renamed as (

    select
        jid,
        docid,
        docstate,
        createdby,
        mimetype,
        datarev,
        activityid,
        usermessage,
        userprofileid,
        duid,
        createdate,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
