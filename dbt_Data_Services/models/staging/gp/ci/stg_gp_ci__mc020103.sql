with

source as (

    select * from {{ source('ci_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        docdate,
        ordatkn,
        dcstatus,
        orbktfrt,
        orchkttl,
        obkpuramt,
        exchdate,
        time1,
        curncyid,
        orccdamt,
        rtclcmtd,
        ordocamt,
        ochgamt,
        opuramt,
        orctrxam,
        odisamtav,
        vendorid,
        orbktmsc,
        or1099am,
        ratetpid,
        orwrofam,
        orappamt,
        ortdisam,
        ototpay,
        orfrtamt,
        denxrate,
        ordistkn,
        xchgrate,
        unganlos,
        rmmcerrs,
        pmntnmbr,
        orchkamt,
        ortaxamt,
        mctrxstt,
        omiscamt,
        dex_row_id,
        currnidx,
        orgapdisctkn,
        origbackouttradedisc,
        exgtblid,
        orddlrat,
        orcasamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
