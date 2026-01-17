with dim_notes as (
    select * from {{ ref('int_ifs__dim_document_text') }}

)

select * from dim_notes
