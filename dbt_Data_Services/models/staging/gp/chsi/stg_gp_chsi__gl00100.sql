with source as (

    select * from {{ source('chsi_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actalias,
        creatddt,
        userdef1,
        postprin,
        modifdt,
        actnumbr_9,
        usrdefs2,
        actnumbr_3,
        adjinfl,
        postivin,
        actnumbr_6,
        mnacsgmt,
        userdef2,
        pstngtyp,
        postpurchin,
        clear_balance,
        postslsin,
        actnumbr_2,
        actnumbr_5,
        tpclblnc,
        accatnum,
        actdescr,
        fxdorvar,
        actnumbr_8,
        inflaequ,
        actnumbr_10,
        workflow_status,
        acctentr,
        active,
        dex_row_ts,
        dex_row_id,
        actnumbr_4,
        usrdefs1,
        actnumbr_7,
        balfrclc,
        dsplkups,
        actnumbr_1,
        decplacs,
        hstrclrt,
        cnvrmthd,
        accttype,
        inflarev,
        noteindx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
