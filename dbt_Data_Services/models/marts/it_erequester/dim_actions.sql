with main as (
    select 
        historyid,
        requisitionstatusid,
        formid,
        snapshotid,
        actionid,
        recordid,
        regexp_replace(comments, '<[^>]*>', '') as comments,
        transactiondate,
        userid,
        description,
        requisitionid,
        clientipaddress,
        hireid,
    from {{ ref('stg_erequester__history') }}
)
select * from main
