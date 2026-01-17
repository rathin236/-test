with

source as (

    select * from {{ source('erequester_dbo', 'history') }}

),

renamed as (

    select
        historyid,
        requisitionstatusid,
        formid,
        snapshotid,
        actionid,
        recordid,
        comments,
        transactiondate,
        userid,
        description,
        requisitionid,
        clientipaddress,
        hireid,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
