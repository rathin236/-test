with

source as (

    select * from {{ source('erequester_dbo', 'routingnodedetail') }}

),

renamed as (

    select
        nodedetid,
        delegateforid,
        userid,
        substituted,
        notifyonly,
        preapproved,
        ooostatus,
        nodeid,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
