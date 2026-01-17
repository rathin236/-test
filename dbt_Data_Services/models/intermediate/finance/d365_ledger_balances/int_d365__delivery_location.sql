with logistics_postal_address as (
    select {{ trim_columns_int('stg_d365__logistics_postal_address') }} 
    from {{ ref('stg_d365__logistics_postal_address') }} --where location = '5637155076'
),

logistics_location as (
    select {{ trim_columns_int('stg_d365__logistics_location') }}
    from {{ ref('stg_d365__logistics_location') }}
),

logistics_address_country_region as (
    select {{ trim_columns_int('stg_d365__logistics_address_country_region') }}
    from {{ ref('stg_d365__logistics_address_country_region') }}
),

cust_table as (
    select {{ trim_columns_int('stg_d365__cust_table') }}
    from {{ ref('stg_d365__cust_table') }}
),

dir_party_table as (
    select {{ trim_columns_int('stg_d365__dir_party_table') }}
    from {{ ref('stg_d365__dir_party_table') }} --where recid = '5637498578'
),

logistics_postal_address_view as (
    select
        lpa.county,
        lpa.district,
        lpa.address,
        lpa.city,
        lpa.countryregionid,
        lpa.latitude,
        lpa.state,
        lpa.street,
        lpa.streetnumber,
        lpa.timezone,
        lpa.longitude,
        lpa.zipcode,
        lpa.location,
        lpa.validfrom,
        lpa.validto,
        lpa.recid as postal_address_rec_id,
        lpa.recid as postal_address,
        lpa.districtname,
        lpa.flatid_ru,
        lpa.houseid_ru,
        lpa.streetid_ru,
        lpa.isprivate,
        lpa.privateforparty,
        lpa.recid as x_rec_id_logistics_postal_address,
        lpa.recversion as x_rec_version_logistics_postal_address,
        lpa.cityrecid,
        lpa.partition,
        lpa.recid,
        lacr.partition as partition_2,
        logl.description as location_name,
        logl.partition as partition_3

    from logistics_postal_address as lpa

    cross join logistics_address_country_region as lacr

    cross join logistics_location as logl

    where --lpa.countryregionid = lacr.countryregionid
        lpa.partition = lacr.partition
        and lpa.location = logl.recid
        and lpa.partition = logl.partition

),

dir_party_delivery_address as (
    select

        dpl.party,
        dpl.location,
        lpav.postal_address as delivery_address,
        dpl.recid as party_location,
        dpl.isprimary,
        dpl.islocationowner,
        dpl.isprimarytaxregistration,
        dpl.recid as table_rec_id,
        dpl.partition,
        dpl.recid,
        lpav.location_name,
        lpav.address,
        lpav.streetnumber,
        lpav.street,
        lpav.city,
        lpav.zipcode,
        lpav.state,
        lpav.county,
        lpav.countryregionid,
        lpav.district,
        lpav.timezone,
        lpav.longitude,
        lpav.latitude,
        lpav.location,
        lpav.validfrom,
        lpav.validto,
        lpav.isprivate,
        lpav.districtname,
        lpav.streetid_ru,
        lpav.houseid_ru,
        lpav.flatid_ru,
        lpav.privateforparty,
        lpav.x_rec_id_logistics_postal_address,
        lpav.x_rec_version_logistics_postal_address,
        lpav.cityrecid,
        lpav.partition as partition_2

from {{ ref('stg_d365__dir_party_location') }} as dpl

    left outer join logistics_postal_address_view as lpav
        on dpl.location = lpav.location
            and dpl.partition = lpav.partition

)
 --select distinct * from dir_party_delivery_address where delivery_address is not null --and delivery_address = '5637338827'
--  and delivery_address = '5637543580' and party = '5637151195'
,

dlv_address as (
    select
        cust.dataareaid as company,
        cust.accountnum as cust_account_number,
        cust.invoiceaccount,
        cust.custgroup,
        cust.party,
        dpt.recid as party_id, 
        dpt.name, 
        dpt.namesalias, 
        dpt.partytype, 
        dpt.partynumber, 
        dpt.logisticslocation_primaryaddress_locationid as primary_location,
        dppa.location_name,
        dppa.address,
        dppa.street,
        dppa.city,
        dppa.zipcode,
        dppa.countryregionid,
        dppa.state,
        dppa.district,
        dppa.timezone,
        dppa.cityrecid,
        dppa.delivery_address,
        md5(concat(cust.accountnum, dppa.delivery_address)) as sk_cust_id

    from cust_table as cust

    left join dir_party_table as dpt
        on cust.party = dpt.recid

    left join dir_party_delivery_address as dppa
        on dpt.recid = dppa.party

    where sk_cust_id is not null
)

select distinct * from dlv_address -- where cust_account_number = 'C1000120'