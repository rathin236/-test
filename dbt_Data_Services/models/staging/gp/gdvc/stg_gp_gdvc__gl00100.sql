with source as (

    select * from {{ source('gdvc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        noteindx,
        inflarev,
        fxdorvar,
        clear_balance,
        actnumbr_2,
        actnumbr_10,
        accatnum,
        dex_row_ts,
        actnumbr_8,
        actnumbr_5,
        adjinfl,
        actnumbr_4,
        usrdefs1,
        actnumbr_1,
        postslsin,
        dex_row_id,
        actnumbr_7,
        workflow_status,
        pstngtyp,
        actalias,
        hstrclrt,
        acctentr,
        usrdefs2,
        actnumbr_3,
        tpclblnc,
        dsplkups,
        creatddt,
        postpurchin,
        actdescr,
        userdef1,
        active,
        userdef2,
        decplacs,
        inflaequ,
        cnvrmthd,
        accttype,
        actnumbr_9,
        balfrclc,
        postprin,
        modifdt,
        actnumbr_6,
        postivin,
        mnacsgmt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
