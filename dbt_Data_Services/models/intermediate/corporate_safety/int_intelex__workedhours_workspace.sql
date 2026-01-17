with workedhours as (
    select * from {{ ref('int_intelex__workhours') }}
),

workspace as (
    select * from {{ ref('int_intelex__workspaces') }}
),

joined as (
    select
        wks.rownum,
        wks.location_name,
        wks.location_id,
        wks.location_code,
        wks.description,
        wks.city,
        wks.state_province,
        wks.country,
        wks.parent_location,
        wks.parent_location_id,
        wks.company_name,
        wks.line_business,
        wks.updated,
        wks.id,
        wkh.month,
        wkh.year,
        wkh.worked_hours,
        case lower(wkh.month)
            when 'january' then 1
            when 'february' then 2
            when 'march' then 3
            when 'april' then 4
            when 'may' then 5
            when 'june' then 6
            when 'july' then 7
            when 'august' then 8
            when 'september' then 9
            when 'october' then 10
            when 'november' then 11
            when 'december' then 12
        end as month_number
    from workspace as wks
    left join workedhours as wkh
        on wks.location_id = wkh.location_id
)

select * from joined
