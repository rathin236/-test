with flattened_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        localities.value:"CompanyAreaId"::number as companyareaid,
        localities.value:"CompanyAreaTitle"::string as companyareatitle,
        localities.value:"Id"::number as id,
        localities.value:"MapCenterCoordinates"::string as mapcentercoordinates,
        localities.value:"ModulId"::number as modulid,
        localities.value:"Name"::string as name,
        localities.value:"OperationsManagerName"::string as operationsmanagername
    from
        {{ source('aquacom', 'localities_raw') }},
        lateral flatten(input => {{ source('aquacom', 'localities_raw') }}.json_data) as localities
),

coordinates_split as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        companyareaid,
        companyareatitle,
        id,
        parse_json(mapcentercoordinates):Lat::string as lattitude,
        parse_json(mapcentercoordinates):Lng::string as longitude,
        modulid,
        name,
        operationsmanagername,
        case
            when row_number() over (partition by id order by create_date desc) = 1 then 1
            else 0
        end as is_active
    from
        flattened_data
),

final as (
    select
        companyareaid,
        companyareatitle,
        id,
        lattitude,
        longitude,
        modulid,
        name,
        operationsmanagername,
        is_active,
        _fivetran_batch,
        _fivetran_synced,
        create_date
    from
        coordinates_split
)

select * from final
where is_active = 1
    and id is not null
