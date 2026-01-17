with source as (

    select * from {{ source('wfc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        dex_row_ts,
        pstngtyp,
        actnumbr_1,
        acctentr,
        actnumbr_4,
        actnumbr_7,
        fxdorvar,
        active,
        clear_balance,
        dex_row_id,
        userdef2,
        postprin,
        usrdefs1,
        mnacsgmt,
        decplacs,
        accttype,
        cnvrmthd,
        balfrclc,
        userdef1,
        actnumbr_3,
        dsplkups,
        postpurchin,
        actnumbr_6,
        actdescr,
        postivin,
        actalias,
        actnumbr_9,
        modifdt,
        workflow_status,
        creatddt,
        adjinfl,
        accatnum,
        hstrclrt,
        noteindx,
        inflaequ,
        actnumbr_2,
        actnumbr_5,
        usrdefs2,
        actnumbr_8,
        inflarev,
        tpclblnc,
        postslsin,
        actnumbr_10,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
