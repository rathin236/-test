with source as (

    select * from {{ source('tns_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        exchdate,
        ototpay,
        pmntnmbr,
        ochgamt,
        rmmcerrs,
        dex_row_id,
        orappamt,
        exgtblid,
        unganlos,
        orfrtamt,
        xchgrate,
        orchkttl,
        ortaxamt,
        obkpuramt,
        docdate,
        time1,
        mctrxstt,
        ordistkn,
        ortdisam,
        orwrofam,
        ordatkn,
        orbktfrt,
        omiscamt,
        ratetpid,
        opuramt,
        denxrate,
        vendorid,
        orctrxam,
        orddlrat,
        orchkamt,
        orccdamt,
        currnidx,
        orgapdisctkn,
        orbktmsc,
        curncyid,
        or1099am,
        ordocamt,
        orcasamt,
        odisamtav,
        dcstatus,
        origbackouttradedisc,
        rtclcmtd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
