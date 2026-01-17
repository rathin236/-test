with

source as (

    select * from {{ source('cai_data_store_sharepoint_dbo', 'tns_lotdowngrade_master') }}

),

renamed as (

    select
        tns_dg_formname,
        downgradetype9,
        downgradetype6count,
        downgradetype1,
        julianyear,
        downgradetype3count,
        submittime,
        downgradetype7,
        downgradetype10,
        downgradetype3,
        lotcertification,
        downgradetype8count,
        downgradetype1count,
        downgradetype10count,
        linenumber,
        selectedlinenumber,
        lot,
        downgradetype4count,
        downgradetype5,
        downgradetype2count,
        downgradetype7count,
        warehouse,
        rowid,
        farmcage,
        downgradetype5count,
        downgradetype2,
        downgradetype8,
        processcode,
        downgradetype9count,
        downgradetype6,
        process,
        downgradetype4,
        juliandate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
