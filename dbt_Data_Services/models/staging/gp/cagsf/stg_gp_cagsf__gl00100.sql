with source as (

    select * from {{ source('cagsf_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        active,
        actnumbr_1,
        inflaequ,
        dex_row_id,
        postprin,
        acctentr,
        actnumbr_7,
        pstngtyp,
        actnumbr_4,
        dsplkups,
        hstrclrt,
        modifdt,
        postpurchin,
        actnumbr_3,
        inflarev,
        accatnum,
        actnumbr_9,
        mnacsgmt,
        tpclblnc,
        actnumbr_6,
        userdef2,
        clear_balance,
        cnvrmthd,
        postslsin,
        noteindx,
        userdef1,
        postivin,
        usrdefs1,
        actnumbr_2,
        actdescr,
        fxdorvar,
        workflow_status,
        actnumbr_8,
        creatddt,
        actnumbr_5,
        usrdefs2,
        dex_row_ts,
        actnumbr_10,
        adjinfl,
        decplacs,
        actalias,
        balfrclc,
        accttype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
