with source as (

    select * from {{ source('caukh_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_7,
        actnumbr_4,
        userdef2,
        adjinfl,
        actnumbr_1,
        accttype,
        mnacsgmt,
        dsplkups,
        decplacs,
        clear_balance,
        pstngtyp,
        dex_row_ts,
        postprin,
        usrdefs2,
        actalias,
        accatnum,
        fxdorvar,
        tpclblnc,
        postpurchin,
        balfrclc,
        postivin,
        usrdefs1,
        acctentr,
        creatddt,
        modifdt,
        active,
        postslsin,
        actnumbr_9,
        actnumbr_10,
        actnumbr_6,
        hstrclrt,
        dex_row_id,
        actnumbr_3,
        inflaequ,
        cnvrmthd,
        noteindx,
        workflow_status,
        actnumbr_8,
        userdef1,
        actnumbr_5,
        actnumbr_2,
        actdescr,
        inflarev,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
