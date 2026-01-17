with flattened_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        workorder.value:"CompletedDate"::string as completeddate,
        workorder.value:"DateCreated"::string as datecreated,
        workorder.value:"DueDate"::string as duedate,
        workorder.value:"Id"::number as id,
        workorder.value:"LocalityId"::number as localityid,
        workorder.value:"LocalityName"::string as localityname,
        workorder.value:"ResponsibleUserName"::string as responsibleusername,
        workorder.value:"StatusId"::number as statusid,
        workorder.value:"StatusName"::string as statusname,
        workorder.value:"Title"::string as title,
        workorder.value:"WorkOrderTypeName"::string as workordertypename
    from
        {{ source('aquacom', 'work_orders_raw') }},
        lateral flatten(input => {{ source('aquacom', 'work_orders_raw') }}.json_data:"Workorders") as workorder
),

final as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        completeddate,
        datecreated,
        duedate,
        id,
        localityid,
        localityname,
        responsibleusername,
        statusid,
        statusname,
        title,
        workordertypename,
        case
            when row_number() over (partition by id order by create_date desc) = 1 then 1
            else 0
        end as is_active
    from
        flattened_data
)

select * from final
where is_active = 1
