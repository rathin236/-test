with invent_location as (
    select * from {{ ref('stg_d365__invent_location') }}
),

invent_location_logistics_location as (
    select * from {{ ref('stg_d365__invent_location_logistics_location') }}
),

logistics_postal_address_view as (
    select * from {{ ref('int_d365__logistics_postal_address_view') }}
),

warehouse_mapped as (
    select {{ trim_columns_int('d365__warehouse_mapping') }} from {{ ref('d365__warehouse_mapping') }}
),

dim_warehouse as (
    select

        invl.inventlocationid as "Warehouse_SK",
        coalesce(warehouse_mapped.New_Warehouse, invl.inventlocationid) as "Mastered Warehouse",
        coalesce(warehouse_mapped.new_warehouse_name, upper(invl.name)) as "Location Name",
        coalesce(warehouse_mapped.New_Warehouse, invl.inventlocationid) as "Location ID",
        coalesce(warehouse_mapped.new_warehouse_name, upper(invl.name)) as "Warehouse Name",
        coalesce(warehouse_mapped.New_Warehouse, invl.inventlocationid) as "Warehouse ID",
        null as "Warehouse Registration Code",
        lpav.address as "Address",
        lpav.street as "Street",
        lpav.city as "City",
        lpav.state as "State",
        lpav.zipcode as "Postal Code",
        lpav.isocode as "Country"

    from invent_location as invl

    left join invent_location_logistics_location as logl
        on invl.recid = logl.inventlocation

    left join logistics_postal_address_view as lpav
        on logl.location = lpav.location

    left join warehouse_mapped
        on cast(trim(invl.inventlocationid) as string) = cast(trim(warehouse_mapped.Old_Warehouse) as string)

    -- left join wh_names as wh_map
    --     on cast(wh_map.new_warehouse as string) = cast(trim(invl.inventlocationid) as string)

    qualify row_number() over (partition by invl.recid order by invl.inventlocationid) = 1

    order by invl.inventlocationid
)

select * from dim_warehouse
-- where "Warehouse_SK" = '1005-09'
