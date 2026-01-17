with flattened_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        inspections.value:"AttachmentCount"::number as attachmentcount,
        inspections.value:"CertificateId"::number as certificateid,
        inspections.value:"Closed"::boolean as closed,
        inspections.value:"ClosedDate"::string as closeddate,
        inspections.value:"CompanyAreaId"::number as companyareaid,
        inspections.value:"CompanyAreaTitle"::string as companyareatitle,
        inspections.value:"Created"::string as created,
        inspections.value:"DriftsutstyrEttersynsTypeId"::number as driftsutstyrettersynstypeid,
        inspections.value:"DriftsutstyrEttersynsTypeNotes"::string as driftsutstyrettersynstypenotes,
        inspections.value:"HasHistoricWeatherData"::boolean as hashistoricweatherdata,
        inspections.value:"HasOperatingEquipment"::boolean as hasoperatingequipment,
        inspections.value:"Id"::number as id,
        inspections.value:"Index"::number as index,
        inspections.value:"InspectionDate"::string as inspectiondate,
        inspections.value:"InspectionIntervalName"::string as inspectionintervalname,
        inspections.value:"LocalityId"::number as localityid,
        inspections.value:"LocalityName"::string as localityname,
        inspections.value:"LocalityNumber"::string as localitynumber,
        inspections.value:"Locked"::boolean as locked,
        inspections.value:"Notes"::string as notes,
        inspections.value:"OperatingStatus"::number as operatingstatus,
        inspections.value:"OperatingStatusDate"::string as operatingstatusdate,
        inspections.value:"OperationsManagerUserId"::number as operationsmanageruserid,
        inspections.value:"OperationsManagerUserName"::string as operationsmanagerusername,
        inspections.value:"PercentCompleted"::number as percentcompleted,
        inspections.value:"PlannedDate"::string as planneddate,
        inspections.value:"SignedBy"::string as signedby,
        inspections.value:"WorkOrderCount"::number as workordercount
    from
        {{ source('aquacom', 'inspections_raw') }},
        lateral flatten(input => {{ source('aquacom', 'inspections_raw') }}.json_data) as inspections
),

final as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        attachmentcount,
        certificateid,
        closed,
        closeddate,
        companyareaid,
        companyareatitle,
        created,
        driftsutstyrettersynstypeid,
        driftsutstyrettersynstypenotes,
        hashistoricweatherdata,
        hasoperatingequipment,
        id,
        index,
        inspectiondate,
        inspectionintervalname,
        localityid,
        localityname,
        localitynumber,
        locked,
        operatingstatus,
        operatingstatusdate,
        operationsmanageruserid,
        operationsmanagerusername,
        percentcompleted,
        planneddate,
        signedby,
        workordercount,
        case
            when row_number() over (partition by id, localityid order by create_date desc) = 1 then 1
            else 0
        end as is_active,
        replace(replace(replace(replace(replace(notes, '<p>', ''), '</p>', ''), '&nbsp;', ''), '<br>', ''), '</br>', '') as notes
    from
        flattened_data
)

select * from final
where is_active = 1
