with source as (

    select * from {{ source('hsi_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        postslsin,
        actnumbr_7,
        actnumbr_4,
        userdef2,
        actnumbr_1,
        postivin,
        workflow_status,
        noteindx,
        clear_balance,
        postpurchin,
        actalias,
        actnumbr_8,
        userdef1,
        actnumbr_5,
        accatnum,
        creatddt,
        tpclblnc,
        adjinfl,
        actnumbr_10,
        usrdefs2,
        modifdt,
        decplacs,
        accttype,
        usrdefs1,
        pstngtyp,
        dsplkups,
        dex_row_ts,
        actnumbr_2,
        actdescr,
        hstrclrt,
        dex_row_id,
        fxdorvar,
        inflaequ,
        active,
        cnvrmthd,
        postprin,
        actnumbr_9,
        mnacsgmt,
        balfrclc,
        inflarev,
        actnumbr_6,
        acctentr,
        actnumbr_3,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
