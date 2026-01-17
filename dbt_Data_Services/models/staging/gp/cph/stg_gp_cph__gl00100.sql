with source as (

    select * from {{ source('cph_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        usrdefs1,
        creatddt,
        modifdt,
        inflaequ,
        actnumbr_9,
        postpurchin,
        tpclblnc,
        balfrclc,
        hstrclrt,
        dex_row_id,
        accttype,
        actnumbr_3,
        cnvrmthd,
        actnumbr_6,
        decplacs,
        postivin,
        postprin,
        clear_balance,
        active,
        inflarev,
        noteindx,
        actnumbr_4,
        userdef2,
        actnumbr_7,
        fxdorvar,
        dex_row_ts,
        acctentr,
        mnacsgmt,
        actnumbr_1,
        accatnum,
        actalias,
        dsplkups,
        usrdefs2,
        actdescr,
        postslsin,
        actnumbr_2,
        actnumbr_5,
        actnumbr_10,
        adjinfl,
        actnumbr_8,
        pstngtyp,
        userdef1,
        workflow_status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
