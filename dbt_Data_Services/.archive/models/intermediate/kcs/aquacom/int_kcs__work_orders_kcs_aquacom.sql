with work_orders as (
    select
        -- Dates
        to_timestamp(_fivetran_synced) as data_sync_datetime,
        to_timestamp(completeddate) as completed_date,
        to_timestamp(datecreated) as created_date,
        to_timestamp(duedate) as due_date,
        -- descriptors
        statusname as status_name,
        title,
        workordertypename as work_order_type_name,
        responsibleusername as responsible_user_name,
        -- PK and SK's
        id as work_order_id,
        localityid as locality_id,
        statusid as status_id

    from {{ ref('stg_aquacom__work_orders') }}
)

select * from work_orders
