with source as (

    select * from {{ source('culc1_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        postslsin,
        active,
        inflaequ,
        dex_row_id,
        workflow_status,
        postivin,
        acctentr,
        actnumbr_8,
        hstrclrt,
        postpurchin,
        actnumbr_10,
        creatddt,
        accatnum,
        adjinfl,
        dex_row_ts,
        inflarev,
        usrdefs1,
        tpclblnc,
        actnumbr_1,
        actnumbr_7,
        actnumbr_4,
        actdescr,
        clear_balance,
        actnumbr_6,
        decplacs,
        accttype,
        pstngtyp,
        actnumbr_3,
        userdef1,
        actnumbr_9,
        actalias,
        usrdefs2,
        modifdt,
        fxdorvar,
        actnumbr_5,
        noteindx,
        actnumbr_2,
        mnacsgmt,
        userdef2,
        postprin,
        cnvrmthd,
        balfrclc,
        dsplkups,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
