with

source as (

    select * from {{ source('nni_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        dex_row_id,
        orcasamt,
        rmmcerrs,
        vendorid,
        ochgamt,
        time1,
        obkpuramt,
        orgapdisctkn,
        origbackouttradedisc,
        ratetpid,
        orappamt,
        pmntnmbr,
        orctrxam,
        odisamtav,
        exchdate,
        ordocamt,
        orddlrat,
        denxrate,
        rtclcmtd,
        currnidx,
        exgtblid,
        dcstatus,
        orchkamt,
        ordatkn,
        orwrofam,
        or1099am,
        ortaxamt,
        orccdamt,
        orbktmsc,
        omiscamt,
        orfrtamt,
        orchkttl,
        curncyid,
        opuramt,
        unganlos,
        mctrxstt,
        docdate,
        orbktfrt,
        xchgrate,
        ortdisam,
        ordistkn,
        ototpay,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
