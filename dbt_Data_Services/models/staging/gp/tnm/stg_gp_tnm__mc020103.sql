with

source as (

    select * from {{ source('tnm_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        mctrxstt,
        pmntnmbr,
        rtclcmtd,
        currnidx,
        orbktfrt,
        denxrate,
        orctrxam,
        curncyid,
        dex_row_id,
        ordocamt,
        exgtblid,
        xchgrate,
        docdate,
        orappamt,
        orwrofam,
        dcstatus,
        ortdisam,
        opuramt,
        ortaxamt,
        obkpuramt,
        omiscamt,
        orddlrat,
        ochgamt,
        ordatkn,
        ordistkn,
        orcasamt,
        vendorid,
        unganlos,
        orfrtamt,
        ototpay,
        orchkttl,
        time1,
        orccdamt,
        origbackouttradedisc,
        orbktmsc,
        odisamtav,
        orchkamt,
        orgapdisctkn,
        or1099am,
        ratetpid,
        rmmcerrs,
        exchdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
