with invent_location as (
    select * from {{ ref('stg_d365__invent_location') }}
),

invent_site as (
    select * from {{ ref('stg_d365__invent_site') }}
),

final as (
    select

        ilo.inventlocationid as "Location ID",
        ilo.name as "Warehouse Name",
        ilo.defaultproductionfinishgoodslocation as "Default Production Finish Goods Location",
        ilo.defaultstatusid as "Default Status ID",
        ilo.printbolbeforeshipconfirm as "Print BOL Before Ship Confirm",
        ilo.uniquecheckdigits as "Unique Check Digits",
        ilo.whsenabled as "WHS Enabled",
        ilo.warehouseautoreleasereservation as "Warehouse Auto Release Reservation",
        ilo.defaultproductioninputlocation as "Default Production Input Location",
        ilo.inventsiteid as "Inventory Site ID",
        isi.name as "Site Name"

    from invent_location as ilo

    left join invent_site as isi
        on ilo.inventsiteid = isi.siteid

    qualify row_number() over (partition by ilo.inventlocationid order by ilo.inventlocationid) = 1

    order by ilo.inventlocationid
)

select * from final