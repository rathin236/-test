with source as (

    select * from {{ source('stusa_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_6,
        cnvrmthd,
        actnumbr_9,
        usrdefs1,
        actdescr,
        postslsin,
        actnumbr_3,
        noteindx,
        userdef1,
        acctentr,
        actnumbr_10,
        postivin,
        workflow_status,
        active,
        actnumbr_2,
        dex_row_ts,
        actnumbr_5,
        clear_balance,
        mnacsgmt,
        balfrclc,
        creatddt,
        modifdt,
        dsplkups,
        pstngtyp,
        accttype,
        decplacs,
        userdef2,
        postprin,
        hstrclrt,
        adjinfl,
        actnumbr_8,
        inflaequ,
        fxdorvar,
        usrdefs2,
        dex_row_id,
        actalias,
        tpclblnc,
        actnumbr_7,
        postpurchin,
        actnumbr_1,
        inflarev,
        accatnum,
        actnumbr_4,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
