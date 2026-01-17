with mf_site as (
    select * from {{ ref('stg_northscope__erpx_mf_site') }}
),

dim_warehouse as (
    select

        to_varchar(sitesk) as "Warehouse_SK",
        to_varchar(sitesk) as "Mastered Warehouse",
        sitename as "Location Name",
        siteid as "Location ID",
        sitename as "Warehouse Name",
        siteid as "Warehouse ID",
        registration as "Warehouse Registration Code",
        case
            when len(coalesce(addressline1, addressline2)) > 0
                then
                    case
                        when addressline1 ilike any ('%c/o%', '%attn%', '%inc%')
                            then concat_ws(', ', addressline2, city, state, zip, country)
                        else concat_ws(', ', coalesce(addressline1, addressline2), city, state, zip, country)
                    end
        end as "Address",
        case
            when addressline1 ilike any ('%c/o%', '%attn%', '%inc%')
                then addressline2
            else coalesce(addressline1, addressline2)
        end as "Street",
        city as "City",
        state as "State",
        zip as "Postal Code",
        country as "Country"

    from mf_site

    qualify row_number() over (partition by sitesk order by siteid) = 1

    order by sitesk
)

select * from dim_warehouse
