with source as (

    select * from {{ source('tns_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        workflow_status,
        hstrclrt,
        dsplkups,
        fxdorvar,
        cnvrmthd,
        inflaequ,
        postslsin,
        actnumbr_4,
        userdef2,
        actnumbr_1,
        adjinfl,
        dex_row_id,
        mnacsgmt,
        modifdt,
        actnumbr_7,
        balfrclc,
        usrdefs1,
        dex_row_ts,
        noteindx,
        inflarev,
        creatddt,
        actnumbr_9,
        actnumbr_6,
        actdescr,
        tpclblnc,
        postprin,
        actnumbr_3,
        accttype,
        actalias,
        decplacs,
        acctentr,
        pstngtyp,
        actnumbr_2,
        active,
        clear_balance,
        postpurchin,
        postivin,
        usrdefs2,
        actnumbr_10,
        actnumbr_8,
        userdef1,
        accatnum,
        actnumbr_5,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
