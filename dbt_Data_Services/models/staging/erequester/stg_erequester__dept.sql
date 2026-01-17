with

source as (

    select * from {{ source('erequester_dbo', 'dept') }}

),

renamed as (

    select
        deptid,
        reselectseg10,
        taxscheduleid,
        deptkey,
        overridesubaccount,
        reselectseg1,
        reselectseg4,
        threshold,
        reselectseg7,
        shiptolocation,
        saitemclassid,
        reselectseg3,
        reselectseg6,
        deptsubkey,
        associateprojectseg,
        description,
        companyid,
        active,
        reselectseg9,
        deptprojkey,
        customerid,
        customfield,
        reselectseg2,
        reselectseg5,
        reselectseg8,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
