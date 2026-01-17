with source as (

    select * from {{ source('ctnm_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        accatnum,
        noteindx,
        fxdorvar,
        cnvrmthd,
        actnumbr_3,
        dex_row_ts,
        dex_row_id,
        actnumbr_6,
        actnumbr_9,
        actalias,
        workflow_status,
        inflaequ,
        balfrclc,
        dsplkups,
        decplacs,
        clear_balance,
        accttype,
        usrdefs1,
        inflarev,
        actnumbr_1,
        modifdt,
        actnumbr_4,
        hstrclrt,
        actnumbr_7,
        postprin,
        adjinfl,
        creatddt,
        mnacsgmt,
        userdef2,
        active,
        postivin,
        usrdefs2,
        actnumbr_5,
        postpurchin,
        acctentr,
        actnumbr_8,
        pstngtyp,
        actnumbr_10,
        postslsin,
        userdef1,
        actdescr,
        tpclblnc,
        actnumbr_2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
