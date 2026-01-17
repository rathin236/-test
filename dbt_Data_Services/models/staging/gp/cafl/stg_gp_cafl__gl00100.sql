with source as (

    select * from {{ source('cafl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        usrdefs2,
        modifdt,
        clear_balance,
        mnacsgmt,
        creatddt,
        actalias,
        inflaequ,
        fxdorvar,
        dsplkups,
        actnumbr_3,
        userdef1,
        hstrclrt,
        actnumbr_6,
        accatnum,
        dex_row_id,
        actnumbr_1,
        cnvrmthd,
        usrdefs1,
        accttype,
        postivin,
        decplacs,
        actnumbr_4,
        postprin,
        actnumbr_7,
        inflarev,
        acctentr,
        actnumbr_5,
        actnumbr_8,
        active,
        balfrclc,
        actnumbr_2,
        noteindx,
        actnumbr_10,
        postpurchin,
        adjinfl,
        userdef2,
        actnumbr_9,
        tpclblnc,
        workflow_status,
        actdescr,
        dex_row_ts,
        postslsin,
        pstngtyp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
