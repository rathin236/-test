with source as (

    select * from {{ source('kcs_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_3,
        userdef1,
        actnumbr_6,
        actdescr,
        acctentr,
        postpurchin,
        postslsin,
        active,
        workflow_status,
        usrdefs2,
        noteindx,
        actnumbr_9,
        actalias,
        mnacsgmt,
        postivin,
        inflarev,
        postprin,
        actnumbr_10,
        actnumbr_5,
        cnvrmthd,
        balfrclc,
        actnumbr_8,
        dsplkups,
        dex_row_ts,
        actnumbr_2,
        creatddt,
        pstngtyp,
        decplacs,
        accttype,
        inflaequ,
        modifdt,
        clear_balance,
        actnumbr_1,
        hstrclrt,
        dex_row_id,
        userdef2,
        adjinfl,
        fxdorvar,
        actnumbr_4,
        actnumbr_7,
        accatnum,
        usrdefs1,
        tpclblnc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
