with source as (

    select * from {{ source('nb601_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        inflaequ,
        postprin,
        postivin,
        cnvrmthd,
        creatddt,
        dsplkups,
        fxdorvar,
        clear_balance,
        balfrclc,
        dex_row_id,
        userdef2,
        noteindx,
        userdef1,
        dex_row_ts,
        usrdefs1,
        usrdefs2,
        mnacsgmt,
        actdescr,
        accatnum,
        actnumbr_10,
        postpurchin,
        acctentr,
        postslsin,
        actalias,
        inflarev,
        accttype,
        decplacs,
        hstrclrt,
        pstngtyp,
        actnumbr_5,
        actnumbr_2,
        tpclblnc,
        adjinfl,
        modifdt,
        actnumbr_8,
        actnumbr_4,
        actnumbr_1,
        workflow_status,
        active,
        actnumbr_7,
        actnumbr_6,
        actnumbr_3,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
