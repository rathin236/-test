with source as (

    select * from {{ source('stva_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        postivin,
        usrdefs1,
        postpurchin,
        balfrclc,
        noteindx,
        acctentr,
        active,
        postslsin,
        actnumbr_2,
        actnumbr_5,
        inflarev,
        actdescr,
        dsplkups,
        mnacsgmt,
        actnumbr_9,
        actnumbr_3,
        workflow_status,
        dex_row_id,
        actnumbr_6,
        actnumbr_4,
        userdef2,
        actnumbr_7,
        pstngtyp,
        hstrclrt,
        decplacs,
        adjinfl,
        actnumbr_1,
        inflaequ,
        accttype,
        tpclblnc,
        modifdt,
        accatnum,
        actalias,
        fxdorvar,
        actnumbr_8,
        cnvrmthd,
        userdef1,
        postprin,
        creatddt,
        clear_balance,
        dex_row_ts,
        actnumbr_10,
        usrdefs2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
