with inspections as (
    select
        -- KPI's
        workordercount as work_order_count,
        percentcompleted as pct_completed,
        attachmentcount as attachment_count,
        -- Status'
        case
            when closed = 'true' then 'Closed'
            when closed = 'false' then 'Open'
            else 'N/A'
        end as inspection_status,
        operatingstatus as operating_status,
        -- Dates
        to_timestamp(_fivetran_synced) as data_sync_datetime,
        to_timestamp(created) as create_datetime,
        to_timestamp(closeddate) as closed_datetime,
        to_timestamp(inspectiondate) as inspection_datetime,
        date(operatingstatusdate) as operating_status_date,
        date(planneddate) as planned_date,
        -- flags
        hashistoricweatherdata as has_historic_weather_data,
        hasoperatingequipment as has_operating_equipment,
        locked as is_locked,
        -- descriptors
        driftsutstyrettersynstypeid as inspection_type_id,
        driftsutstyrettersynstypenotes as inspection_type_notes,
        inspectionintervalname as inspection_interval_name,
        signedby as inspection_signed_by,
        notes as inspection_notes,
        -- PK and SK's
        localityid as locality_id,
        localitynumber as locality_number,
        id,
        certificateid as certificate_id
    
    from {{ ref('stg_aquacom__inspections') }}
)

select * from inspections
