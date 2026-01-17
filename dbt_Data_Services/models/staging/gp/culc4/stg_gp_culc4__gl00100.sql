with source as (

    select * from {{ source('culc4_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_8,
        creatddt,
        modifdt,
        postslsin,
        actnumbr_2,
        cnvrmthd,
        workflow_status,
        actnumbr_5,
        balfrclc,
        inflaequ,
        postivin,
        actnumbr_10,
        dex_row_id,
        userdef2,
        actnumbr_9,
        fxdorvar,
        tpclblnc,
        postpurchin,
        actdescr,
        accatnum,
        adjinfl,
        inflarev,
        decplacs,
        actalias,
        dex_row_ts,
        accttype,
        userdef1,
        actnumbr_3,
        postprin,
        actnumbr_6,
        mnacsgmt,
        hstrclrt,
        pstngtyp,
        usrdefs2,
        clear_balance,
        actnumbr_1,
        actnumbr_4,
        dsplkups,
        usrdefs1,
        noteindx,
        acctentr,
        actnumbr_7,
        active,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
