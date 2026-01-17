with source as (

    select * from {{ source('ci_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        usrdefs1,
        usrdefs2,
        actnumbr_4,
        actnumbr_7,
        dex_row_id,
        actnumbr_3,
        actnumbr_6,
        actnumbr_9,
        actnumbr_5,
        actnumbr_8,
        adjinfl,
        fxdorvar,
        acctentr,
        cnvrmthd,
        postivin,
        postprin,
        inflaequ,
        creatddt,
        noteindx,
        actnumbr_10,
        workflow_status,
        actnumbr_1,
        mnacsgmt,
        actdescr,
        actnumbr_2,
        pstngtyp,
        dex_row_ts,
        balfrclc,
        modifdt,
        decplacs,
        accttype,
        inflarev,
        clear_balance,
        userdef2,
        postslsin,
        userdef1,
        dsplkups,
        postpurchin,
        actalias,
        accatnum,
        hstrclrt,
        tpclblnc,
        active,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
