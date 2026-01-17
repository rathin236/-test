with view_harvest_catch_final as (
    select * from {{ ref('int_kontali_view_ha_ca_version2') }}
)

select * from view_harvest_catch_final
