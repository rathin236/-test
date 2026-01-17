with

source as (

    select * from {{ source('kcs_dbo', 'sy00500') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        glbchval,
        series,
        apprvldt,
        rclpstdt,
        modifdt,
        computer_check_doc_date,
        errstate,
        uselastdayofmonth,
        bchsttus,
        delbach,
        sort_checks_by,
        approvl,
        bachdate,
        posttogl,
        pmtmethod,
        bchcomnt,
        cardname,
        creatddt,
        curncyid,
        cntrltrx,
        noteindx,
        bchemsg2,
        brkdnall,
        clearrecamts,
        mkdtopst,
        glpostdt,
        aprvluserid,
        bchstrg2,
        bchemsg1,
        reprnted,
        dex_row_id,
        numoftrx,
        bachfreq,
        purchasingprepaymentbch,
        chkfrmts,
        nofpstgs,
        seprmtnc,
        time1,
        bchstrg1,
        rvrsbach,
        workflow_status,
        chksprtd,
        cntrltot,
        origin,
        bchtotal,
        workflow_approval_status,
        mscbdinc,
        chekbkid,
        workflow_priority,
        petrxcnt,
        userid,
        trxsorce,
        eftfileformat,
        recpstgs,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
