with source as (

    select * from {{ source('cgdv2_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_4,
        accatnum,
        userdef2,
        modifdt,
        actnumbr_7,
        dex_row_id,
        creatddt,
        inflaequ,
        fxdorvar,
        cnvrmthd,
        mnacsgmt,
        workflow_status,
        actnumbr_1,
        actalias,
        hstrclrt,
        postivin,
        postpurchin,
        postslsin,
        usrdefs2,
        clear_balance,
        dex_row_ts,
        actdescr,
        actnumbr_2,
        actnumbr_10,
        active,
        userdef1,
        actnumbr_5,
        actnumbr_8,
        acctentr,
        adjinfl,
        usrdefs1,
        tpclblnc,
        dsplkups,
        actnumbr_9,
        postprin,
        pstngtyp,
        noteindx,
        actnumbr_3,
        decplacs,
        actnumbr_6,
        accttype,
        balfrclc,
        inflarev,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
