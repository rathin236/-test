with source as (

    select * from {{ source('aaa_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        active,
        postslsin,
        cnvrmthd,
        balfrclc,
        postpurchin,
        hstrclrt,
        inflarev,
        actnumbr_1,
        acctentr,
        accatnum,
        inflaequ,
        actnumbr_10,
        actnumbr_2,
        dex_row_ts,
        workflow_status,
        actdescr,
        noteindx,
        actnumbr_8,
        userdef1,
        pstngtyp,
        actnumbr_5,
        creatddt,
        decplacs,
        clear_balance,
        actalias,
        actnumbr_6,
        usrdefs2,
        accttype,
        actnumbr_3,
        modifdt,
        tpclblnc,
        mnacsgmt,
        actnumbr_9,
        adjinfl,
        dsplkups,
        actnumbr_7,
        usrdefs1,
        actnumbr_4,
        userdef2,
        fxdorvar,
        postprin,
        postivin,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
