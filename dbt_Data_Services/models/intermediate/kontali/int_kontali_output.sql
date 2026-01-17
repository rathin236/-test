with curve_output as (
    select
        root.json_data:name::varchar(256) as curvename,
        root.category::varchar(256) as curvecategory,
        root.json_data:timeseries_type::varchar(256) as timeseries_type,
        val.value:timestamp::timestamp as timestamp,
        (year(val.value:timestamp::timestamp))::varchar(255) as year,
        (month(val.value:timestamp::timestamp))::varchar(255) as month,
        val.value:updated_at::timestamp as updated_at,
        val.value:value::string as value
    from {{ ref('stg_kontali__kontali_api_response') }} as root,
        lateral flatten(input => json_data:timeseries) as val
)

select * from curve_output
