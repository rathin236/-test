with source as (

    select * from {{ source('lbfl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        dex_row_id,
        postpurchin,
        balfrclc,
        actnumbr_8,
        hstrclrt,
        clear_balance,
        userdef2,
        dsplkups,
        workflow_status,
        tpclblnc,
        actnumbr_7,
        active,
        creatddt,
        actnumbr_4,
        postslsin,
        acctentr,
        actnumbr_1,
        pstngtyp,
        dex_row_ts,
        usrdefs1,
        inflaequ,
        actnumbr_3,
        userdef1,
        noteindx,
        adjinfl,
        usrdefs2,
        inflarev,
        actnumbr_9,
        actalias,
        mnacsgmt,
        actnumbr_6,
        modifdt,
        accatnum,
        cnvrmthd,
        postprin,
        actnumbr_10,
        accttype,
        decplacs,
        fxdorvar,
        actnumbr_5,
        actnumbr_2,
        postivin,
        actdescr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
