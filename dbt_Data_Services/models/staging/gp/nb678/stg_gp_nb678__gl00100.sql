with source as (

    select * from {{ source('nb678_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_7,
        tpclblnc,
        postprin,
        actnumbr_1,
        actnumbr_4,
        creatddt,
        active,
        adjinfl,
        noteindx,
        actnumbr_3,
        postivin,
        inflarev,
        clear_balance,
        dsplkups,
        actnumbr_6,
        accttype,
        balfrclc,
        actnumbr_9,
        userdef2,
        inflaequ,
        mnacsgmt,
        decplacs,
        cnvrmthd,
        workflow_status,
        usrdefs1,
        actnumbr_10,
        accatnum,
        dex_row_id,
        fxdorvar,
        actnumbr_2,
        actnumbr_5,
        postpurchin,
        hstrclrt,
        dex_row_ts,
        actdescr,
        userdef1,
        acctentr,
        modifdt,
        actnumbr_8,
        pstngtyp,
        usrdefs2,
        actalias,
        postslsin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
