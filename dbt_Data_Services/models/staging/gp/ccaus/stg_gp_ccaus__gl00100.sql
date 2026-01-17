with source as (

    select * from {{ source('ccaus_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        usrdefs1,
        inflaequ,
        tpclblnc,
        postprin,
        dex_row_id,
        accttype,
        actnumbr_9,
        acctentr,
        actnumbr_6,
        active,
        dsplkups,
        creatddt,
        modifdt,
        actnumbr_3,
        inflarev,
        pstngtyp,
        postslsin,
        dex_row_ts,
        actnumbr_4,
        workflow_status,
        actnumbr_1,
        userdef2,
        clear_balance,
        actnumbr_7,
        cnvrmthd,
        mnacsgmt,
        accatnum,
        actalias,
        hstrclrt,
        adjinfl,
        noteindx,
        postpurchin,
        usrdefs2,
        balfrclc,
        decplacs,
        actnumbr_2,
        actnumbr_10,
        fxdorvar,
        actdescr,
        userdef1,
        postivin,
        actnumbr_8,
        actnumbr_5,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
