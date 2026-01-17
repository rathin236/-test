with source as (

    select * from {{ source('gmg_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        hstrclrt,
        postpurchin,
        postivin,
        usrdefs1,
        actdescr,
        actnumbr_9,
        balfrclc,
        modifdt,
        acctentr,
        inflarev,
        active,
        creatddt,
        actnumbr_8,
        tpclblnc,
        actnumbr_5,
        inflaequ,
        clear_balance,
        workflow_status,
        usrdefs2,
        actnumbr_2,
        actalias,
        postslsin,
        userdef1,
        actnumbr_10,
        pstngtyp,
        actnumbr_1,
        adjinfl,
        dsplkups,
        noteindx,
        userdef2,
        actnumbr_7,
        accatnum,
        dex_row_ts,
        actnumbr_4,
        postprin,
        mnacsgmt,
        accttype,
        fxdorvar,
        cnvrmthd,
        actnumbr_3,
        actnumbr_6,
        decplacs,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
