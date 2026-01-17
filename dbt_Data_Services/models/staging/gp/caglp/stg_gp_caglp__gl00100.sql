with source as (

    select * from {{ source('caglp_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        dex_row_ts,
        actnumbr_9,
        usrdefs1,
        inflaequ,
        actnumbr_6,
        actdescr,
        postprin,
        decplacs,
        userdef1,
        actnumbr_3,
        actnumbr_10,
        accttype,
        noteindx,
        tpclblnc,
        actnumbr_8,
        adjinfl,
        actnumbr_5,
        actnumbr_2,
        mnacsgmt,
        pstngtyp,
        workflow_status,
        cnvrmthd,
        userdef2,
        clear_balance,
        modifdt,
        postslsin,
        accatnum,
        creatddt,
        usrdefs2,
        balfrclc,
        inflarev,
        actalias,
        hstrclrt,
        postpurchin,
        fxdorvar,
        actnumbr_7,
        acctentr,
        actnumbr_4,
        postivin,
        dex_row_id,
        actnumbr_1,
        active,
        dsplkups,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
