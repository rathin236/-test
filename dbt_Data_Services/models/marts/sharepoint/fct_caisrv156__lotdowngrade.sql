with grouped as (
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype1 as downgradetype
        ,downgradetype1count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype2 as downgradetype
        ,downgradetype2count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype3 as downgradetype
        ,downgradetype3count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype4 as downgradetype
        ,downgradetype4count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype5 as downgradetype
        ,downgradetype5count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype6 as downgradetype
        ,downgradetype6count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype7 as downgradetype
        ,downgradetype7count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype8 as downgradetype
        ,downgradetype8count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}
    
    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype9 as downgradetype
        ,downgradetype9count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}

    union all
    
    select rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,submittime
        ,downgradetype10 as downgradetype
        ,downgradetype10count as downgradecount
        ,processcode
        ,selectedlinenumber
    from {{ ref('int_caisrv156__lot_downgrade_combined') }}
),

final as (
    select 
        rowid
        ,warehouse
        ,process
        ,lot
        ,farmcage
        ,lotcertification
        ,juliandate
        ,julianyear
        ,dateadd(day, juliandate - 1, to_date(concat(julianyear, '-01-01'))) as actual_date 
        ,submittime
        ,downgradetype
        ,downgradecount
        ,concat(selectedlinenumber,processcode) as linenumber
    from grouped
)

select * from final
