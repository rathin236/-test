with source as (

    select * from {{ source('cstus_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        postivin,
        postpurchin,
        clear_balance,
        actnumbr_2,
        usrdefs1,
        actnumbr_5,
        actnumbr_8,
        adjinfl,
        actnumbr_10,
        dex_row_ts,
        actnumbr_3,
        userdef1,
        hstrclrt,
        noteindx,
        actnumbr_6,
        actdescr,
        tpclblnc,
        workflow_status,
        actnumbr_9,
        accatnum,
        postslsin,
        pstngtyp,
        active,
        dsplkups,
        mnacsgmt,
        acctentr,
        userdef2,
        inflaequ,
        dex_row_id,
        fxdorvar,
        usrdefs2,
        creatddt,
        inflarev,
        postprin,
        actalias,
        decplacs,
        modifdt,
        actnumbr_1,
        actnumbr_4,
        accttype,
        balfrclc,
        actnumbr_7,
        cnvrmthd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
