with source as (

    select * from {{ source('cpqln_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_4,
        userdef2,
        actnumbr_7,
        postpurchin,
        balfrclc,
        actnumbr_1,
        creatddt,
        hstrclrt,
        postivin,
        dex_row_id,
        cnvrmthd,
        workflow_status,
        accttype,
        postprin,
        decplacs,
        actnumbr_6,
        mnacsgmt,
        noteindx,
        actnumbr_9,
        adjinfl,
        actnumbr_3,
        usrdefs1,
        dex_row_ts,
        actdescr,
        actnumbr_2,
        pstngtyp,
        fxdorvar,
        actalias,
        active,
        clear_balance,
        userdef1,
        actnumbr_5,
        inflaequ,
        postslsin,
        actnumbr_8,
        inflarev,
        actnumbr_10,
        usrdefs2,
        tpclblnc,
        dsplkups,
        acctentr,
        accatnum,
        modifdt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
