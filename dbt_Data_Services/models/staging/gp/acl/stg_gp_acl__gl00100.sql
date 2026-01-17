with source as (

    select * from {{ source('acl_dbo', 'gl00100') }}

),

renamed as (

    select
        actindx,
        actnumbr_9,
        clear_balance,
        actnumbr_6,
        actdescr,
        actnumbr_3,
        actalias,
        hstrclrt,
        postpurchin,
        adjinfl,
        decplacs,
        dex_row_ts,
        mnacsgmt,
        accttype,
        actnumbr_7,
        postivin,
        modifdt,
        balfrclc,
        postprin,
        usrdefs1,
        cnvrmthd,
        creatddt,
        dex_row_id,
        fxdorvar,
        active,
        inflaequ,
        accatnum,
        actnumbr_4,
        noteindx,
        userdef2,
        actnumbr_1,
        acctentr,
        actnumbr_2,
        actnumbr_10,
        pstngtyp,
        usrdefs2,
        workflow_status,
        tpclblnc,
        dsplkups,
        userdef1,
        actnumbr_8,
        actnumbr_5,
        postslsin,
        inflarev,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
