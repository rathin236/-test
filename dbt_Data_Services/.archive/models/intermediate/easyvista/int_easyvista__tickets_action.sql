with main as (
    select *
    from {{ ref('stg_easyvista__tickets_action') }}
),

flatten as (
    select
        main.rfc_number,
        main.insert_date,
        main.modified_from,
        main.modified_to,
        record.value:ACTION_ID::string as action_id,
        record.value:ACTION_LABEL_EN::string as action_label_en,
        record.value:ACTION_NUMBER::string as action_number,
        record.value:CREATION_DATE_UT::string as creation_date_ut,
        record.value:END_DATE_UT::string as end_date_ut,
        record.value:ACTION_TYPE:ACTION_TYPE_ID::string as action_type_id,
        record.value:ACTION_TYPE:NAME_EN::string as action_type_name,
        record.value:DONE_BY:EMPLOYEE_ID::string as done_by_employee_id,
        record.value:DONE_BY:E_MAIL::string as done_by_email,
        record.value:DONE_BY:LAST_NAME::string as done_by_name,
        record.value:GROUP_ID::string as group_id
    from main,
        lateral flatten(input => main.json_data:records) as record
    qualify
        row_number()
            over (
                partition by record.value:ACTION_ID order by main.insert_date
            )
        = 1
)

select * from flatten
