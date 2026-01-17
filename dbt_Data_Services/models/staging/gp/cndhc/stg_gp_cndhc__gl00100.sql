with source as (

    select * from {{ source('cndhc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        dsplkups,
        accatnum,
        actnumbr_3,
        userdef1,
        workflow_status,
        actnumbr_6,
        actdescr,
        actalias,
        actnumbr_9,
        inflaequ,
        creatddt,
        postslsin,
        dex_row_id,
        cnvrmthd,
        adjinfl,
        actnumbr_7,
        pstngtyp,
        userdef2,
        usrdefs1,
        mnacsgmt,
        tpclblnc,
        postprin,
        accttype,
        dex_row_ts,
        actnumbr_1,
        decplacs,
        acctentr,
        actnumbr_4,
        balfrclc,
        postpurchin,
        active,
        postivin,
        modifdt,
        clear_balance,
        actnumbr_2,
        hstrclrt,
        actnumbr_5,
        usrdefs2,
        actnumbr_8,
        fxdorvar,
        inflarev,
        actnumbr_10,
        noteindx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
