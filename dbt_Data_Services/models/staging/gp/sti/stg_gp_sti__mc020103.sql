with

source as (

    select * from {{ source('sti_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        ordocamt,
        opuramt,
        or1099am,
        obkpuramt,
        orgapdisctkn,
        origbackouttradedisc,
        xchgrate,
        orbktfrt,
        rtclcmtd,
        omiscamt,
        mctrxstt,
        orddlrat,
        dex_row_id,
        ordatkn,
        ochgamt,
        exgtblid,
        orappamt,
        ratetpid,
        orbktmsc,
        orfrtamt,
        orchkttl,
        ortaxamt,
        orccdamt,
        ortdisam,
        curncyid,
        orwrofam,
        docdate,
        odisamtav,
        ordistkn,
        pmntnmbr,
        dcstatus,
        orctrxam,
        orcasamt,
        denxrate,
        ototpay,
        exchdate,
        orchkamt,
        currnidx,
        time1,
        rmmcerrs,
        vendorid,
        unganlos,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
