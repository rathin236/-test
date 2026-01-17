-- ======================================================================
-- DO NOT OVERWRITE THIS FILE
-- Use it to pass your schema name, database name and required tables 
-- save it and compile the code to autogenerate your source yml code
-- Revert any changes you would made on this stub
-- ======================================================================

{{ codegen.generate_source(
    schema_name = 'schema',
    database_name = 'db',
    table_names = ['tbl_1', 'tbl_2', 'tbl_3' ]) }}
