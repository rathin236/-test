with source as (

    select * from {{ source('tnsus_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        usrdefs1,
        balfrclc,
        postpurchin,
        postslsin,
        clear_balance,
        workflow_status,
        actnumbr_9,
        creatddt,
        hstrclrt,
        modifdt,
        postivin,
        fxdorvar,
        actnumbr_6,
        adjinfl,
        actnumbr_3,
        tpclblnc,
        accatnum,
        actnumbr_4,
        actnumbr_7,
        pstngtyp,
        dsplkups,
        userdef2,
        mnacsgmt,
        decplacs,
        noteindx,
        actnumbr_1,
        dex_row_id,
        actalias,
        inflaequ,
        acctentr,
        actdescr,
        postprin,
        dex_row_ts,
        active,
        usrdefs2,
        actnumbr_5,
        cnvrmthd,
        actnumbr_2,
        actnumbr_10,
        accttype,
        userdef1,
        actnumbr_8,
        inflarev,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
