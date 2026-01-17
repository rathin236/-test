with curve_output as (
    select
        root.json_data:name::varchar(256) as curvename,
        root.category::varchar(256) as curvecategory,
        root.lastupdatedate::timestamp as lastupdatedate,
        root.json_data:timeseries_type::varchar(256) as timeseries_type,
        val.value:value::string as curve_val,
        --val.value:timestamp::timestamp as timestamp,
        --val.value:timestamp::varchar(256) as timestamp,
        (year(convert_timezone('UTC', to_timestamp_ltz(val.value:timestamp::timestamp))))::varchar(255) as year,
        (month(convert_timezone('UTC', to_timestamp_ltz(val.value:timestamp::timestamp))))::varchar(255) as month,
        convert_timezone('UTC', to_timestamp_ltz(val.value:timestamp::timestamp)) as timestamp,
        convert_timezone('UTC', to_timestamp_ltz(val.value:updated_at::timestamp)) as updated_at
    from (
        select distinct
            resp."Curve_Name",
            resp.lastupdatedate,
            resp.json_data,
            resp."Start_date",
            resp."End_Date",
            resp.category,
            resp.executionid
        from {{ ref('stg_kontali__kontali_api_response') }} as resp
        inner join
            (
                select
                    api_res."Curve_Name",
                    max(api_res.lastupdatedate) as max_date
                from {{ ref('stg_kontali__kontali_api_response') }} as api_res
                group by api_res."Curve_Name"
            ) as sub
            on resp."Curve_Name" = sub."Curve_Name"
                and resp.lastupdatedate = sub.max_date
    ) as root,
        lateral flatten(input => json_data:timeseries) as val
)

select * from curve_output
