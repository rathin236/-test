with source as (

    select * from {{ source('ctnus_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        modifdt,
        inflaequ,
        accatnum,
        usrdefs1,
        creatddt,
        fxdorvar,
        dex_row_id,
        cnvrmthd,
        actnumbr_9,
        actalias,
        hstrclrt,
        noteindx,
        postslsin,
        usrdefs2,
        dsplkups,
        actdescr,
        active,
        actnumbr_10,
        actnumbr_2,
        inflarev,
        acctentr,
        workflow_status,
        actnumbr_5,
        pstngtyp,
        userdef1,
        actnumbr_8,
        actnumbr_4,
        userdef2,
        actnumbr_7,
        tpclblnc,
        postprin,
        adjinfl,
        accttype,
        actnumbr_1,
        clear_balance,
        postivin,
        postpurchin,
        decplacs,
        actnumbr_3,
        balfrclc,
        actnumbr_6,
        mnacsgmt,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
