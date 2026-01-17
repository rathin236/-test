with part_catalog as (
    select * from {{ ref('stg_ifs__document_text_tab') }}
    where output_type = 'PURCHASE'
),

dim_notes as (
    select
        note_id,
        output_type as note_type,
        rowversion as create_date,
        note_text as description
    from part_catalog
)

select
    note_id,
    note_type,
    create_date,
    description
from dim_notes
