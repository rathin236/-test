with source as (

    select * from {{ source('northscope', 'erpx_glaccount') }}

),

renamed as (

    select
        accountsk,
        hostsystemlink,
        accountclasssk,
        glcontrolaccounttypeen,
        gltypicalbalanceen,
        glaccountpostingtypeen,
        useinso,
        useingl,
        useinsp,
        isinactive,
        lastupdated,
        dataentitycompanysk,
        description,
        createddatetime,
        glaccounttypeen,
        useinap,
        lastuser,
        accountnumber,
        createdby,
        useinim,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
