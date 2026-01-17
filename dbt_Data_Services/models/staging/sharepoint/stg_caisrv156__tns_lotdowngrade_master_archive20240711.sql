with

source as (

    select * from {{ source('cai_data_store_sharepoint_dbo', 'tns_lotdowngrade_master_archive20240711') }}

),

renamed as (

    select
        tns_dg_formname,
        downgradetype10,
        lotcertification,
        downgradetype4,
        lot,
        rowid,
        downgradetype2,
        selectedlinenumber,
        downgradetype9,
        downgradetype3count,
        linenumber,
        downgradetype6count,
        downgradetype10count,
        downgradetype7,
        downgradetype9count,
        downgradetype5,
        downgradetype2count,
        downgradetype3,
        downgradetype5count,
        farmcage,
        juliandate,
        warehouse,
        downgradetype1,
        downgradetype8count,
        downgradetype8,
        process,
        julianyear,
        downgradetype1count,
        downgradetype6,
        downgradetype4count,
        submittime,
        processcode,
        downgradetype7count,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
