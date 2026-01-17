with

source as (

    select * from {{ source('gmg_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        time1,
        docdate,
        ordistkn,
        ototpay,
        vendorid,
        orcasamt,
        opuramt,
        orwrofam,
        obkpuramt,
        curncyid,
        dex_row_id,
        ordocamt,
        exchdate,
        ochgamt,
        orappamt,
        currnidx,
        orchkamt,
        orddlrat,
        mctrxstt,
        exgtblid,
        ordatkn,
        pmntnmbr,
        orctrxam,
        odisamtav,
        denxrate,
        dcstatus,
        orbktfrt,
        rtclcmtd,
        omiscamt,
        orccdamt,
        origbackouttradedisc,
        ortdisam,
        ratetpid,
        ortaxamt,
        orgapdisctkn,
        or1099am,
        orfrtamt,
        xchgrate,
        rmmcerrs,
        unganlos,
        orchkttl,
        orbktmsc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
