with source as (

    select * from {{ source('wvcl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        modifdt,
        mnacsgmt,
        workflow_status,
        actnumbr_7,
        accatnum,
        usrdefs2,
        actnumbr_1,
        fxdorvar,
        actnumbr_4,
        actalias,
        userdef2,
        inflarev,
        noteindx,
        creatddt,
        actdescr,
        postivin,
        acctentr,
        inflaequ,
        decplacs,
        actnumbr_8,
        clear_balance,
        active,
        actnumbr_2,
        accttype,
        balfrclc,
        userdef1,
        actnumbr_5,
        cnvrmthd,
        actnumbr_10,
        tpclblnc,
        postprin,
        hstrclrt,
        dsplkups,
        dex_row_ts,
        actnumbr_6,
        actnumbr_9,
        postpurchin,
        adjinfl,
        actnumbr_3,
        pstngtyp,
        postslsin,
        usrdefs1,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
