with source as (

    select * from {{ source('casl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        cnvrmthd,
        workflow_status,
        actnumbr_8,
        clear_balance,
        accatnum,
        postslsin,
        modifdt,
        creatddt,
        dsplkups,
        postivin,
        inflarev,
        actnumbr_10,
        fxdorvar,
        actdescr,
        dex_row_ts,
        actnumbr_5,
        postpurchin,
        userdef1,
        actnumbr_2,
        actalias,
        active,
        inflaequ,
        accttype,
        usrdefs2,
        actnumbr_3,
        dex_row_id,
        tpclblnc,
        acctentr,
        pstngtyp,
        actnumbr_9,
        decplacs,
        actnumbr_6,
        mnacsgmt,
        noteindx,
        postprin,
        actnumbr_4,
        userdef2,
        usrdefs1,
        actnumbr_1,
        balfrclc,
        adjinfl,
        actnumbr_7,
        hstrclrt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
