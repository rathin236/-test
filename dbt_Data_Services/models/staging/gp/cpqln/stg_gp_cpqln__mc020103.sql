with source as (

    select * from {{ source('cpqln_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        ochgamt,
        obkpuramt,
        or1099am,
        dex_row_id,
        rmmcerrs,
        orappamt,
        pmntnmbr,
        ratetpid,
        time1,
        ordistkn,
        orbktfrt,
        ordatkn,
        xchgrate,
        ortaxamt,
        opuramt,
        orddlrat,
        vendorid,
        ototpay,
        exchdate,
        omiscamt,
        denxrate,
        odisamtav,
        currnidx,
        ortdisam,
        orchkamt,
        orwrofam,
        mctrxstt,
        orbktmsc,
        orfrtamt,
        orccdamt,
        orchkttl,
        unganlos,
        docdate,
        orgapdisctkn,
        ordocamt,
        dcstatus,
        exgtblid,
        origbackouttradedisc,
        curncyid,
        orctrxam,
        orcasamt,
        rtclcmtd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
