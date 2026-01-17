with source as (

    select * from {{ source('tnm_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        pstngtyp,
        adjinfl,
        noteindx,
        dex_row_ts,
        inflaequ,
        userdef2,
        accatnum,
        tpclblnc,
        inflarev,
        dex_row_id,
        actnumbr_10,
        workflow_status,
        actnumbr_5,
        actnumbr_8,
        postslsin,
        actdescr,
        actnumbr_2,
        modifdt,
        hstrclrt,
        actnumbr_3,
        balfrclc,
        userdef1,
        creatddt,
        postivin,
        dsplkups,
        mnacsgmt,
        usrdefs2,
        actnumbr_6,
        actalias,
        postpurchin,
        actnumbr_9,
        actnumbr_7,
        fxdorvar,
        actnumbr_1,
        clear_balance,
        actnumbr_4,
        accttype,
        cnvrmthd,
        acctentr,
        postprin,
        decplacs,
        active,
        usrdefs1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
