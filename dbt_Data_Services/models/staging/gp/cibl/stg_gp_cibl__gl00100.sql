with source as (

    select * from {{ source('cibl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        acctentr,
        fxdorvar,
        inflarev,
        userdef2,
        actnumbr_8,
        actnumbr_10,
        cnvrmthd,
        dsplkups,
        usrdefs1,
        actnumbr_4,
        actnumbr_1,
        accttype,
        balfrclc,
        postprin,
        actnumbr_7,
        decplacs,
        actnumbr_6,
        actdescr,
        actnumbr_3,
        userdef1,
        dex_row_id,
        postivin,
        inflaequ,
        actnumbr_9,
        actalias,
        adjinfl,
        dex_row_ts,
        usrdefs2,
        postpurchin,
        workflow_status,
        mnacsgmt,
        creatddt,
        actnumbr_5,
        tpclblnc,
        actnumbr_2,
        accatnum,
        pstngtyp,
        active,
        noteindx,
        hstrclrt,
        modifdt,
        postslsin,
        clear_balance,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
