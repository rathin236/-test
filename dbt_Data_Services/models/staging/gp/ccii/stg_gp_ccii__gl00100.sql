with source as (

    select * from {{ source('ccii_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        balfrclc,
        inflarev,
        actnumbr_3,
        userdef1,
        postivin,
        modifdt,
        postslsin,
        usrdefs2,
        clear_balance,
        actnumbr_6,
        mnacsgmt,
        actnumbr_9,
        actalias,
        hstrclrt,
        postprin,
        actnumbr_4,
        accatnum,
        noteindx,
        actnumbr_7,
        tpclblnc,
        adjinfl,
        fxdorvar,
        dex_row_id,
        dex_row_ts,
        creatddt,
        postpurchin,
        usrdefs1,
        acctentr,
        active,
        decplacs,
        inflaequ,
        pstngtyp,
        actnumbr_1,
        userdef2,
        cnvrmthd,
        actnumbr_10,
        dsplkups,
        accttype,
        workflow_status,
        actnumbr_5,
        actnumbr_8,
        actdescr,
        actnumbr_2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
