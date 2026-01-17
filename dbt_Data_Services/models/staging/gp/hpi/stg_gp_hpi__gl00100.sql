with source as (

    select * from {{ source('hpi_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        tpclblnc,
        postprin,
        actalias,
        noteindx,
        userdef1,
        modifdt,
        actnumbr_9,
        actnumbr_6,
        actnumbr_3,
        mnacsgmt,
        usrdefs2,
        dex_row_id,
        postpurchin,
        postslsin,
        actnumbr_5,
        pstngtyp,
        active,
        dsplkups,
        actnumbr_2,
        actdescr,
        creatddt,
        acctentr,
        dex_row_ts,
        workflow_status,
        adjinfl,
        actnumbr_8,
        accatnum,
        fxdorvar,
        actnumbr_10,
        inflarev,
        clear_balance,
        hstrclrt,
        userdef2,
        balfrclc,
        usrdefs1,
        actnumbr_7,
        actnumbr_4,
        postivin,
        inflaequ,
        actnumbr_1,
        accttype,
        cnvrmthd,
        decplacs,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
