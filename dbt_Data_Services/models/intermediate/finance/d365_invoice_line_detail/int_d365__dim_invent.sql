with invent_dim as (
    select
        inventlocationid as "Location ID",
        inventsiteid as "Site ID",
        inventdimid,
        recid,
        inventstatusid,
        wmslocationid
    from {{ ref('stg_d365__invent_dim') }}
    where inventdimid is not null
)

select distinct * from invent_dim
