with source as (

    select * from {{ source('cfami_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        cnvrmthd,
        postivin,
        accatnum,
        userdef2,
        userdef1,
        fxdorvar,
        creatddt,
        inflarev,
        usrdefs1,
        usrdefs2,
        acctentr,
        mnacsgmt,
        actdescr,
        tpclblnc,
        actnumbr_10,
        hstrclrt,
        actalias,
        postpurchin,
        inflaequ,
        dsplkups,
        postslsin,
        adjinfl,
        active,
        decplacs,
        accttype,
        actnumbr_3,
        pstngtyp,
        actnumbr_6,
        balfrclc,
        actnumbr_9,
        actnumbr_1,
        actnumbr_4,
        actnumbr_7,
        actnumbr_8,
        actnumbr_2,
        actnumbr_5,
        dex_row_id,
        workflow_status,
        clear_balance,
        dex_row_ts,
        noteindx,
        postprin,
        modifdt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
