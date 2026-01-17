with source as (

    select * from {{ source('cos_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        workflow_status,
        actnumbr_6,
        actdescr,
        actnumbr_3,
        postivin,
        clear_balance,
        actalias,
        postpurchin,
        fxdorvar,
        actnumbr_5,
        actnumbr_2,
        actnumbr_10,
        usrdefs2,
        dex_row_id,
        accatnum,
        tpclblnc,
        postslsin,
        userdef1,
        adjinfl,
        actnumbr_8,
        accttype,
        inflarev,
        dsplkups,
        pstngtyp,
        userdef2,
        actnumbr_7,
        actnumbr_4,
        dex_row_ts,
        actnumbr_1,
        acctentr,
        hstrclrt,
        mnacsgmt,
        creatddt,
        active,
        postprin,
        usrdefs1,
        decplacs,
        modifdt,
        noteindx,
        inflaequ,
        balfrclc,
        cnvrmthd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
