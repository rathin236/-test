with

source as (

    select * from {{ source('erequester_dbo', 'usercompany') }}

),

renamed as (

    select
        companyid,
        userid,
        canapproveitems,
        defaultwarehouse,
        requesttypeid,
        lastupdatedby,
        transapprovallimitenabled,
        canexpenseoutsidevendors,
        canpostpicklists,
        userequestdepts,
        cansearchfull,
        userequesttypes,
        useprojects,
        caneditreqs,
        usereceivingdelegate,
        canadminacct,
        useshippinglocations,
        changetnc,
        canexpenseotherusers,
        acctuserid,
        lastupdateddate,
        expensevendorid,
        canpostreqs,
        transapprovallimit,
        canapprovevendors,
        caneditreqnotes,
        canexpensemanagement,
        canreceivedept,
        canreceive,
        billtolocationid,
        usergl,
        useusergloverride,
        canpostap,
        deptid,
        ccexpensevendorid,
        usetargetcompanies,
        caneditdefaults,
        locationid,
        active,
        ptproxy,
        limitformresponseaccess,
        isproxyapprover,
        levelid,
        canreceivefullaccess,
        rerouteoriguserid,
        caneditwaitingreqs,
        supervisorid,
        customfield1,
        canreceivereadonly,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
