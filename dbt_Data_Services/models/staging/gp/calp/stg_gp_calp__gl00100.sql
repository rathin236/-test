with source as (

    select * from {{ source('calp_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_5,
        inflaequ,
        actnumbr_2,
        tpclblnc,
        postprin,
        noteindx,
        accttype,
        actnumbr_8,
        usrdefs1,
        clear_balance,
        actnumbr_1,
        acctentr,
        balfrclc,
        userdef1,
        fxdorvar,
        decplacs,
        actalias,
        postivin,
        actnumbr_10,
        dex_row_id,
        usrdefs2,
        cnvrmthd,
        workflow_status,
        mnacsgmt,
        hstrclrt,
        dsplkups,
        actnumbr_7,
        active,
        inflarev,
        actnumbr_4,
        actdescr,
        postpurchin,
        accatnum,
        actnumbr_9,
        adjinfl,
        modifdt,
        pstngtyp,
        postslsin,
        userdef2,
        actnumbr_6,
        dex_row_ts,
        actnumbr_3,
        creatddt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
