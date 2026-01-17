with source as (

    select * from {{ source('cai_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        tpclblnc,
        postprin,
        inflaequ,
        active,
        actnumbr_10,
        decplacs,
        accttype,
        actnumbr_9,
        dex_row_id,
        dsplkups,
        actnumbr_3,
        actnumbr_6,
        balfrclc,
        postpurchin,
        modifdt,
        fxdorvar,
        inflarev,
        usrdefs1,
        acctentr,
        dex_row_ts,
        creatddt,
        postivin,
        clear_balance,
        cnvrmthd,
        mnacsgmt,
        actnumbr_7,
        hstrclrt,
        usrdefs2,
        postslsin,
        actnumbr_1,
        actnumbr_4,
        actalias,
        userdef2,
        accatnum,
        actdescr,
        adjinfl,
        actnumbr_8,
        pstngtyp,
        actnumbr_2,
        actnumbr_5,
        workflow_status,
        noteindx,
        userdef1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
