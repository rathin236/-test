with source as (
    select
        created_date,
        parse_json(json_data) as json_data
    from {{ ref('stg__pronto_forms_timesheet_json') }}
),

flattened_answers as (
    select
        source.json_data:form.name::string as form_name,
        source.created_date as date_submitted,
        f.value:label::string as label,
        f.value:values[0]::string as value_str
    from source,
        lateral flatten(input => source.json_data:pages[0].sections[0].answers) as f

),

final as (
    select
        form_name,
        max(case
            when lower(trim(label)) = 'date' then value_str
        end)::date as timesheet_date,

        date_submitted,

        max(case
            when lower(trim(label)) = 'vessel' then upper(value_str)
        end) as vessel,
        max(case
            when lower(trim(label)) in ('captain', 'cpn') then upper(value_str)
        end) as captain_name

    from flattened_answers
    group by form_name, date_submitted

    qualify row_number() over (
            partition by
                form_name,
                max(case when lower(trim(label)) = 'vessel' then upper(value_str) end),
                max(case when lower(trim(label)) in ('captain', 'cpn') then upper(value_str) end),
                max(case when lower(trim(label)) = 'date' then value_str end)::date
            order by date_submitted desc
        ) = 1
)

select * from final
