with source as (

    select * from {{ source('cwavc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        active,
        userdef1,
        actnumbr_6,
        actdescr,
        hstrclrt,
        acctentr,
        dsplkups,
        dex_row_ts,
        pstngtyp,
        fxdorvar,
        inflaequ,
        actnumbr_9,
        actalias,
        workflow_status,
        accttype,
        cnvrmthd,
        postprin,
        actnumbr_10,
        decplacs,
        creatddt,
        usrdefs2,
        actnumbr_8,
        balfrclc,
        actnumbr_2,
        actnumbr_5,
        noteindx,
        clear_balance,
        postpurchin,
        actnumbr_1,
        actnumbr_4,
        userdef2,
        adjinfl,
        modifdt,
        postivin,
        mnacsgmt,
        postslsin,
        actnumbr_7,
        dex_row_id,
        inflarev,
        accatnum,
        tpclblnc,
        usrdefs1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
