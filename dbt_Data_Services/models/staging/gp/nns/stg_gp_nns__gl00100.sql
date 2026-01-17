with source as (

    select * from {{ source('nns_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        dsplkups,
        inflarev,
        clear_balance,
        actnumbr_6,
        actdescr,
        tpclblnc,
        actnumbr_3,
        usrdefs1,
        accttype,
        modifdt,
        balfrclc,
        postprin,
        decplacs,
        userdef1,
        actnumbr_5,
        actnumbr_2,
        mnacsgmt,
        pstngtyp,
        userdef2,
        acctentr,
        active,
        fxdorvar,
        accatnum,
        workflow_status,
        cnvrmthd,
        dex_row_id,
        actnumbr_8,
        postslsin,
        dex_row_ts,
        creatddt,
        actnumbr_10,
        hstrclrt,
        postivin,
        inflaequ,
        usrdefs2,
        actnumbr_7,
        actnumbr_4,
        actalias,
        adjinfl,
        actnumbr_1,
        noteindx,
        postpurchin,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
