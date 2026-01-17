with

source as (

    select * from {{ source('monday', 'timeentries') }}

),

renamed as (

    select
        execution_id,
        user,
        updated_date,
        date,
        parent_item,
        billable_minutes,
        item,
        team,
        id,
        created_date,
        board,
        status,
        minutes

    from source

)

select * from renamed
