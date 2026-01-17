with source as (

    select * from {{ source('tnscl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_1,
        decplacs,
        actnumbr_4,
        userdef2,
        hstrclrt,
        actnumbr_7,
        clear_balance,
        pstngtyp,
        fxdorvar,
        mnacsgmt,
        postprin,
        cnvrmthd,
        modifdt,
        inflarev,
        balfrclc,
        creatddt,
        usrdefs1,
        accttype,
        active,
        dsplkups,
        inflaequ,
        noteindx,
        postslsin,
        acctentr,
        dex_row_ts,
        dex_row_id,
        postpurchin,
        actnumbr_3,
        workflow_status,
        actnumbr_6,
        actnumbr_9,
        actalias,
        postivin,
        usrdefs2,
        actnumbr_8,
        accatnum,
        actnumbr_10,
        userdef1,
        actdescr,
        actnumbr_2,
        tpclblnc,
        adjinfl,
        actnumbr_5,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
