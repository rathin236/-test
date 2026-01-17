with source as (
    select * from {{ source('erequester_dbo', 'reqtopo') }}
),

renamed as (
    select
        poid,
        requisitionid,
        ponumber,
        tncfileid,
        emailto,
        reviewuserid,
        _fivetran_deleted,
        _fivetran_synced

    from source
)

select * from renamed
