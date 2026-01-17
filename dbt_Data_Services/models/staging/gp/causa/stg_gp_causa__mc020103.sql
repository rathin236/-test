with

source as (

    select * from {{ source('causa_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        dex_row_id,
        curncyid,
        ratetpid,
        dcstatus,
        docdate,
        origbackouttradedisc,
        orappamt,
        obkpuramt,
        or1099am,
        ochgamt,
        exchdate,
        xchgrate,
        orchkttl,
        orfrtamt,
        orbktmsc,
        opuramt,
        exgtblid,
        unganlos,
        time1,
        pmntnmbr,
        omiscamt,
        orccdamt,
        orbktfrt,
        ortaxamt,
        ototpay,
        ordistkn,
        ortdisam,
        orctrxam,
        orddlrat,
        denxrate,
        rmmcerrs,
        ordatkn,
        mctrxstt,
        orchkamt,
        orwrofam,
        vendorid,
        orgapdisctkn,
        rtclcmtd,
        orcasamt,
        odisamtav,
        currnidx,
        ordocamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
