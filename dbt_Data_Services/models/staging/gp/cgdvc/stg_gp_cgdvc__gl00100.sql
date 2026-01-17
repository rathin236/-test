with source as (

    select * from {{ source('cgdvc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        fxdorvar,
        usrdefs2,
        mnacsgmt,
        actalias,
        creatddt,
        actnumbr_3,
        userdef1,
        actnumbr_6,
        cnvrmthd,
        accatnum,
        acctentr,
        dsplkups,
        noteindx,
        active,
        pstngtyp,
        postslsin,
        clear_balance,
        actnumbr_1,
        usrdefs1,
        actnumbr_4,
        actnumbr_7,
        workflow_status,
        actnumbr_5,
        actnumbr_8,
        actnumbr_2,
        postprin,
        balfrclc,
        dex_row_id,
        actnumbr_10,
        accttype,
        adjinfl,
        tpclblnc,
        decplacs,
        actdescr,
        dex_row_ts,
        actnumbr_9,
        hstrclrt,
        userdef2,
        inflarev,
        postpurchin,
        inflaequ,
        modifdt,
        postivin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
