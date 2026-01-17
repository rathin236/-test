with

source as (

    select * from {{ source('tnsc_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        dcstatus,
        orbktfrt,
        ratetpid,
        pmntnmbr,
        curncyid,
        time1,
        opuramt,
        or1099am,
        exgtblid,
        obkpuramt,
        orgapdisctkn,
        origbackouttradedisc,
        rtclcmtd,
        orchkamt,
        orddlrat,
        ordatkn,
        mctrxstt,
        orappamt,
        orctrxam,
        odisamtav,
        currnidx,
        ordocamt,
        dex_row_id,
        docdate,
        ordistkn,
        unganlos,
        orbktmsc,
        orcasamt,
        orwrofam,
        rmmcerrs,
        ochgamt,
        exchdate,
        omiscamt,
        denxrate,
        vendorid,
        ortaxamt,
        orccdamt,
        ototpay,
        xchgrate,
        orchkttl,
        orfrtamt,
        ortdisam,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
