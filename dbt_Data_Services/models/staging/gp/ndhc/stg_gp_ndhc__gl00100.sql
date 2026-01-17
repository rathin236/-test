with source as (

    select * from {{ source('ndhc_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_8,
        dsplkups,
        balfrclc,
        tpclblnc,
        postprin,
        actnumbr_5,
        dex_row_ts,
        actnumbr_2,
        postslsin,
        adjinfl,
        usrdefs1,
        noteindx,
        accttype,
        actnumbr_1,
        creatddt,
        modifdt,
        inflarev,
        clear_balance,
        active,
        pstngtyp,
        workflow_status,
        actnumbr_7,
        actnumbr_4,
        dex_row_id,
        actnumbr_10,
        actalias,
        usrdefs2,
        inflaequ,
        accatnum,
        actdescr,
        acctentr,
        userdef1,
        cnvrmthd,
        decplacs,
        hstrclrt,
        actnumbr_6,
        postpurchin,
        postivin,
        actnumbr_3,
        fxdorvar,
        actnumbr_9,
        mnacsgmt,
        userdef2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
