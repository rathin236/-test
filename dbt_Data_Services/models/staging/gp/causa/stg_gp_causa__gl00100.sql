with source as (

    select * from {{ source('causa_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_5,
        actnumbr_8,
        active,
        workflow_status,
        inflaequ,
        actnumbr_2,
        creatddt,
        postpurchin,
        postivin,
        fxdorvar,
        hstrclrt,
        actnumbr_10,
        modifdt,
        actnumbr_1,
        usrdefs1,
        postprin,
        adjinfl,
        actnumbr_4,
        decplacs,
        accttype,
        cnvrmthd,
        actnumbr_7,
        balfrclc,
        clear_balance,
        usrdefs2,
        mnacsgmt,
        dex_row_ts,
        actalias,
        pstngtyp,
        noteindx,
        actnumbr_3,
        userdef1,
        inflarev,
        actnumbr_6,
        actdescr,
        dsplkups,
        userdef2,
        actnumbr_9,
        accatnum,
        tpclblnc,
        postslsin,
        acctentr,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
