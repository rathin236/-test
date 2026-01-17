with source as (

    select * from {{ source('sti_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        accttype,
        actalias,
        acctentr,
        pstngtyp,
        inflarev,
        usrdefs2,
        actdescr,
        dex_row_ts,
        active,
        userdef1,
        dsplkups,
        actnumbr_4,
        noteindx,
        actnumbr_1,
        hstrclrt,
        actnumbr_7,
        balfrclc,
        postprin,
        cnvrmthd,
        inflaequ,
        decplacs,
        modifdt,
        actnumbr_8,
        workflow_status,
        clear_balance,
        actnumbr_10,
        postpurchin,
        adjinfl,
        postivin,
        actnumbr_5,
        fxdorvar,
        creatddt,
        actnumbr_2,
        usrdefs1,
        userdef2,
        dex_row_id,
        accatnum,
        actnumbr_6,
        tpclblnc,
        actnumbr_3,
        mnacsgmt,
        actnumbr_9,
        postslsin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
