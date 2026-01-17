with source as (

    select * from {{ source('kcs_dbo', 'mc020103') }}

),

renamed as (

    select
        doctype,
        vchrnmbr,
        orbktfrt,
        obkpuramt,
        orgapdisctkn,
        denxrate,
        orchkamt,
        opuramt,
        or1099am,
        vendorid,
        origbackouttradedisc,
        ordatkn,
        orddlrat,
        rmmcerrs,
        omiscamt,
        ortaxamt,
        orchkttl,
        unganlos,
        ototpay,
        ortdisam,
        xchgrate,
        orccdamt,
        orfrtamt,
        pmntnmbr,
        ordistkn,
        orcasamt,
        mctrxstt,
        dex_row_id,
        curncyid,
        orbktmsc,
        time1,
        docdate,
        ochgamt,
        exgtblid,
        dcstatus,
        orwrofam,
        orctrxam,
        exchdate,
        orappamt,
        odisamtav,
        currnidx,
        rtclcmtd,
        ordocamt,
        ratetpid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where _fivetran_deleted = 'False'
