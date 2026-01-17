with source as (

    select * from {{ source('culcg_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        tpclblnc,
        active,
        creatddt,
        dsplkups,
        hstrclrt,
        actnumbr_1,
        postpurchin,
        usrdefs1,
        actnumbr_7,
        accttype,
        decplacs,
        actnumbr_4,
        modifdt,
        userdef2,
        inflarev,
        acctentr,
        postivin,
        balfrclc,
        postprin,
        cnvrmthd,
        actalias,
        actnumbr_3,
        fxdorvar,
        noteindx,
        dex_row_id,
        usrdefs2,
        actnumbr_9,
        mnacsgmt,
        dex_row_ts,
        actnumbr_6,
        accatnum,
        clear_balance,
        inflaequ,
        postslsin,
        adjinfl,
        workflow_status,
        actnumbr_2,
        actnumbr_10,
        actdescr,
        actnumbr_8,
        pstngtyp,
        actnumbr_5,
        userdef1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
