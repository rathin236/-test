with source as (

    select * from {{ source('inspec_fbd', 'qcbhconditionfactor') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (
    select
        {{ adapter.quote("_ID") }},
        {{ adapter.quote("MATURETRAITS_MATURE") }},
        {{ adapter.quote("LOTDETAILS") }},
        {{ adapter.quote("STATUS_WORKFLOW") }},
        {{ adapter.quote("APPROVAL_STATUS") }},
        {{ adapter.quote("MATURETRAITS_LARGEKYPE") }},
        {{ adapter.quote("CONTEXT_ENTERPRISE") }},
        {{ adapter.quote("MATURETRAITS_DARKSKIN") }},
        {{ adapter.quote("SHIFT") }},
        {{ adapter.quote("CONTEXT_PLANT") }},
        {{ adapter.quote("MATURETRAITS_BIGHEAD") }},
        {{ adapter.quote("WIDTH_UOM") }},
        {{ adapter.quote("STATUS_LASTMODIFIED") }},
        {{ adapter.quote("OFFICIALTIME") }},
        {{ adapter.quote("STATUSOVERRIDEREASON") }},
        {{ adapter.quote("FORMPASSFAIL") }},
        {{ adapter.quote("APPROVAL_DATETIME") }},
        {{ adapter.quote("FORMID") }},
        {{ adapter.quote("SUPERVISOR") }},
        {{ adapter.quote("MATURETRAITS_THINBELLY") }},
        {{ adapter.quote("INSTRUCTIONS") }},
        {{ adapter.quote("DATE_DATESTRING") }},
        {{ adapter.quote("GINDEX") }},
        {{ adapter.quote("MATURETRAITS_NOTMATURE") }},
        {{ adapter.quote("APPROVAL_USER") }},
        {{ adapter.quote("DATE") }},
        {{ adapter.quote("TOTAL_SCORE") }},
        {{ adapter.quote("LENGTH") }},
        {{ adapter.quote("DATE_TIMESTRING") }},
        {{ adapter.quote("ROUNDWEIGHTLBS") }},
        {{ adapter.quote("KFULTONFACTOR") }},
        {{ adapter.quote("LENGTHCM_UOM") }},
        {{ adapter.quote("LENGHTINCM") }},
        {{ adapter.quote("STATUS_LASTMODIFIEDBY") }},
        {{ adapter.quote("GUTOUTWEIGHTLBS") }},
        {{ adapter.quote("WALLTIME") }},
        {{ adapter.quote("L") }},
        {{ adapter.quote("LOTVALUE_SUBFORM") }},
        {{ adapter.quote("FACILITY") }},
        {{ adapter.quote("GONADSWEIGHT_UOM") }},
        {{ adapter.quote("QUALITY") }},
        {{ adapter.quote("LOT_LOT") }},
        {{ adapter.quote("STATUS_CREATEDBY") }},
        {{ adapter.quote("ROUNDWEIGHTINGRS") }},
        {{ adapter.quote("DATE_TIMEDATESTRING") }},
        {{ adapter.quote("CONTEXT") }},
        {{ adapter.quote("W") }},
        {{ adapter.quote("GONADSWEIGHT") }},
        {{ adapter.quote("WIDTHCM") }},
        {{ adapter.quote("_FIVETRAN_DELETED") }},
        {{ adapter.quote("_FIVETRAN_SYNCED") }}

    from filtered
)

select * from renamed
