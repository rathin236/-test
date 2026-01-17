with source as (

    select * from {{ source('cgcag_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        cnvrmthd,
        workflow_status,
        actnumbr_10,
        accatnum,
        dsplkups,
        inflaequ,
        actnumbr_5,
        fxdorvar,
        actnumbr_8,
        actnumbr_2,
        adjinfl,
        postpurchin,
        active,
        usrdefs1,
        dex_row_id,
        actdescr,
        noteindx,
        userdef1,
        acctentr,
        creatddt,
        dex_row_ts,
        pstngtyp,
        usrdefs2,
        inflarev,
        actalias,
        modifdt,
        postslsin,
        actnumbr_7,
        actnumbr_4,
        accttype,
        actnumbr_1,
        tpclblnc,
        clear_balance,
        hstrclrt,
        actnumbr_3,
        balfrclc,
        postivin,
        decplacs,
        userdef2,
        actnumbr_9,
        postprin,
        actnumbr_6,
        mnacsgmt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
