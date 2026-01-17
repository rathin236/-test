with source as (

    select * from {{ source('inspec_fbd', 'qcfbdemployeegmp') }}

),

renamed as (

    select

        {{ adapter.quote("_ID") }},
        {{ adapter.quote("PHOTO") }},
        {{ adapter.quote("FORMID") }},
        {{ adapter.quote("SUPERVISORNAME") }},
        {{ adapter.quote("CONTEXT_PLANT") }},
        {{ adapter.quote("STATUS_CREATEDBY") }},
        {{ adapter.quote("OFFENDERNAME") }},
        {{ adapter.quote("COMMENTS") }},
        {{ adapter.quote("DESCRIPTIONOFDEFICIENCY") }},
        {{ adapter.quote("CONTEXT_ENTERPRISE") }},
        {{ adapter.quote("STATUS_WORKFLOW") }},
        {{ adapter.quote("STATUSOVERRIDEREASON") }},
        {{ adapter.quote("STATUS_LASTMODIFIEDBY") }},
        {{ adapter.quote("TOTAL_SCORE") }},
        {{ adapter.quote("FORMPASSFAIL") }},
        {{ adapter.quote("AREAOFTHEPLANT") }},
        {{ adapter.quote("WASTHEINFRACTIONCORRECTED") }},
        {{ adapter.quote("CONTEXT") }},
        {{ adapter.quote("TYPEOFDEFICIENCY") }},
        {{ adapter.quote("APPROVAL_STATUS") }},
        {{ adapter.quote("APPROVAL_USER") }},
        {{ adapter.quote("STATUS_LASTMODIFIED") }},
        {{ adapter.quote("APPROVAL_DATETIME") }},
        {{ adapter.quote("WALLTIME") }},
        {{ adapter.quote("OFFICIALTIME") }},
        {{ adapter.quote("_FIVETRAN_DELETED") }},
        {{ adapter.quote("_FIVETRAN_SYNCED") }}

    from source

)

select * from renamed
