with source as (

    select * from {{ source('gcags_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        accatnum,
        usrdefs2,
        cnvrmthd,
        actnumbr_3,
        acctentr,
        actnumbr_6,
        fxdorvar,
        hstrclrt,
        actnumbr_9,
        mnacsgmt,
        dsplkups,
        actalias,
        userdef2,
        postivin,
        workflow_status,
        balfrclc,
        actnumbr_1,
        decplacs,
        actnumbr_4,
        noteindx,
        inflaequ,
        accttype,
        inflarev,
        actnumbr_7,
        creatddt,
        usrdefs1,
        dex_row_ts,
        actnumbr_5,
        modifdt,
        actnumbr_8,
        actnumbr_10,
        adjinfl,
        postprin,
        postpurchin,
        dex_row_id,
        pstngtyp,
        active,
        postslsin,
        userdef1,
        actdescr,
        actnumbr_2,
        clear_balance,
        tpclblnc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
