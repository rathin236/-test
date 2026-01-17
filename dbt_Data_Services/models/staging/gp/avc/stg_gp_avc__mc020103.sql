with

source as (

    select * from {{ source('avc_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        ratetpid,
        xchgrate,
        curncyid,
        rmmcerrs,
        or1099am,
        obkpuramt,
        orbktfrt,
        ordocamt,
        pmntnmbr,
        omiscamt,
        ordatkn,
        opuramt,
        orgapdisctkn,
        origbackouttradedisc,
        orchkamt,
        denxrate,
        ototpay,
        docdate,
        exgtblid,
        ortdisam,
        orccdamt,
        mctrxstt,
        orchkttl,
        unganlos,
        orfrtamt,
        exchdate,
        ortaxamt,
        orbktmsc,
        dex_row_id,
        ordistkn,
        orwrofam,
        odisamtav,
        currnidx,
        orcasamt,
        orctrxam,
        orddlrat,
        ochgamt,
        time1,
        orappamt,
        rtclcmtd,
        dcstatus,
        vendorid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
