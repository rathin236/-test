with source as (

    select * from {{ source('culc3_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_7,
        modifdt,
        accttype,
        actnumbr_4,
        decplacs,
        userdef2,
        actnumbr_1,
        tpclblnc,
        mnacsgmt,
        pstngtyp,
        usrdefs2,
        postprin,
        active,
        clear_balance,
        actnumbr_8,
        userdef1,
        actnumbr_5,
        actnumbr_2,
        actdescr,
        acctentr,
        postslsin,
        inflaequ,
        usrdefs1,
        dex_row_id,
        postivin,
        workflow_status,
        balfrclc,
        actnumbr_10,
        actnumbr_9,
        cnvrmthd,
        dsplkups,
        actnumbr_6,
        actnumbr_3,
        actalias,
        noteindx,
        hstrclrt,
        fxdorvar,
        inflarev,
        accatnum,
        dex_row_ts,
        creatddt,
        adjinfl,
        postpurchin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
