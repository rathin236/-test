with unioned as (

    select * from

        {{ dbt_utils.union_relations(
            relations=[ref('stg_inspec_fbd__qcbhconditionfactor'), ref('stg_inspec_blks__qcbhconditionfactor')] 
        ) }}
),

filtered as (

    select * from unioned
    where
        status_workflow = 'Finished'
        and date is not null
        and lotdetails is not null

),

transformed as (

    select

        _id as form_id,
        date::date as created_date,
        coalesce(facility, context_plant) as facility,
        gindex::number as gindex,
        gonadsweight::number as gonadsweight,
        roundweightlbs::number as roundweightlbs,
        length::number as lengthcm,
        lotdetails,
        trim(split({{ 'lotdetails' }}, '/')[0]::text) as lot_id,
        trim(split({{ 'lotdetails' }}, '/')[1]::text) as certification,
        trim(split({{ 'lotdetails' }}, '/')[2]::text) as site_cage,
        case
            when maturetraits_bighead ilike 'big head'
                then 1
            else coalesce(maturetraits_bighead, 0)
        end as is_maturetraits_bighead,
        case
            when maturetraits_thinbelly ilike 'thin belly'
                then 1
            else coalesce(maturetraits_thinbelly, 0)
        end as is_maturetraits_thinbelly,
        case
            when maturetraits_largekype ilike 'large kype'
                then 1
            else coalesce(maturetraits_largekype, 0)
        end as is_maturetraits_largekype,
        case
            when maturetraits_notmature ilike 'not mature'
                then 1
            else coalesce(maturetraits_notmature, 0)
        end as is_maturetraits_notmature,
        kfultonfactor::number as kfultonfactor

    from filtered
),

organized as (

    select

        --pk 
        form_id,

        --fk
        lot_id,

        --details
        ----strings
        certification,
        facility,
        lotdetails,
        site_cage,
        ----numerics
        gonadsweight,
        gindex,
        kfultonfactor,
        lengthcm,
        roundweightlbs,
        ----booleans
        is_maturetraits_bighead,
        is_maturetraits_largekype,
        is_maturetraits_notmature,
        is_maturetraits_thinbelly,
        ----dates
        created_date
        ----timestamps
        --metadata

    from transformed

)

select * from organized
