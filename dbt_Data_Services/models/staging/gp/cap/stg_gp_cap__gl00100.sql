with source as (

    select * from {{ source('cap_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        dex_row_ts,
        actnumbr_8,
        pstngtyp,
        actnumbr_2,
        dsplkups,
        actnumbr_5,
        inflaequ,
        accttype,
        active,
        decplacs,
        postprin,
        hstrclrt,
        acctentr,
        dex_row_id,
        usrdefs1,
        fxdorvar,
        userdef2,
        tpclblnc,
        accatnum,
        actnumbr_6,
        clear_balance,
        actnumbr_9,
        mnacsgmt,
        actnumbr_3,
        postivin,
        actalias,
        postpurchin,
        creatddt,
        userdef1,
        actdescr,
        modifdt,
        postslsin,
        actnumbr_7,
        balfrclc,
        cnvrmthd,
        adjinfl,
        actnumbr_1,
        actnumbr_4,
        workflow_status,
        noteindx,
        actnumbr_10,
        inflarev,
        usrdefs2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
