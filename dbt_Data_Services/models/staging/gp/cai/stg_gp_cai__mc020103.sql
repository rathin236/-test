with

source as (

    select * from {{ source('cai_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        ordatkn,
        orbktfrt,
        dex_row_id,
        curncyid,
        xchgrate,
        time1,
        docdate,
        vendorid,
        pmntnmbr,
        odisamtav,
        rtclcmtd,
        ordocamt,
        or1099am,
        orchkamt,
        orctrxam,
        rmmcerrs,
        orgapdisctkn,
        origbackouttradedisc,
        ratetpid,
        orcasamt,
        dcstatus,
        ordistkn,
        exchdate,
        ototpay,
        orchkttl,
        unganlos,
        orfrtamt,
        orbktmsc,
        orccdamt,
        currnidx,
        orappamt,
        orwrofam,
        exgtblid,
        omiscamt,
        ortaxamt,
        obkpuramt,
        ochgamt,
        mctrxstt,
        ortdisam,
        denxrate,
        orddlrat,
        opuramt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
