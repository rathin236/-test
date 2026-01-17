with source as (

    select * from {{ source('rbf_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        tpclblnc,
        postprin,
        actnumbr_9,
        actdescr,
        actnumbr_6,
        actnumbr_3,
        hstrclrt,
        actalias,
        decplacs,
        accttype,
        pstngtyp,
        clear_balance,
        dsplkups,
        inflaequ,
        mnacsgmt,
        balfrclc,
        adjinfl,
        usrdefs1,
        inflarev,
        cnvrmthd,
        accatnum,
        workflow_status,
        actnumbr_7,
        active,
        actnumbr_4,
        userdef2,
        actnumbr_1,
        dex_row_id,
        noteindx,
        postslsin,
        actnumbr_2,
        dex_row_ts,
        acctentr,
        usrdefs2,
        actnumbr_10,
        postivin,
        creatddt,
        fxdorvar,
        actnumbr_8,
        userdef1,
        actnumbr_5,
        modifdt,
        postpurchin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
