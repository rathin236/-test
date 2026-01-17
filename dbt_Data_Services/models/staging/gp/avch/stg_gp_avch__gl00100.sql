with source as (

    select * from {{ source('avch_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        userdef1,
        acctentr,
        actnumbr_9,
        actalias,
        dex_row_id,
        actnumbr_6,
        actdescr,
        fxdorvar,
        active,
        modifdt,
        inflaequ,
        dex_row_ts,
        accttype,
        inflarev,
        actnumbr_2,
        creatddt,
        usrdefs2,
        actnumbr_8,
        clear_balance,
        actnumbr_5,
        postprin,
        actnumbr_10,
        balfrclc,
        cnvrmthd,
        decplacs,
        actnumbr_1,
        adjinfl,
        postivin,
        postpurchin,
        dsplkups,
        actnumbr_7,
        actnumbr_4,
        workflow_status,
        mnacsgmt,
        tpclblnc,
        usrdefs1,
        hstrclrt,
        accatnum,
        userdef2,
        pstngtyp,
        postslsin,
        noteindx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
