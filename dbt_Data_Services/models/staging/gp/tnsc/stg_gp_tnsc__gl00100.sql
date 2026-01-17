with source as (

    select * from {{ source('tnsc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        fxdorvar,
        accatnum,
        modifdt,
        workflow_status,
        inflarev,
        noteindx,
        active,
        creatddt,
        actnumbr_1,
        actnumbr_4,
        adjinfl,
        pstngtyp,
        clear_balance,
        actnumbr_2,
        actnumbr_10,
        actnumbr_5,
        userdef1,
        actnumbr_8,
        postslsin,
        inflaequ,
        actalias,
        actnumbr_3,
        tpclblnc,
        usrdefs2,
        actnumbr_6,
        actdescr,
        dex_row_id,
        actnumbr_9,
        dex_row_ts,
        hstrclrt,
        postpurchin,
        acctentr,
        usrdefs1,
        actnumbr_7,
        decplacs,
        balfrclc,
        accttype,
        postivin,
        userdef2,
        mnacsgmt,
        cnvrmthd,
        dsplkups,
        postprin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
