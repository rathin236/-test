{# -----------------------------------------------------------------------------
  get_valid_schemas_list(database, required_tables)

  Purpose:
    Return a Python list of schema names in <database> that contain
    ALL of the given required_tables (case-insensitive check).

  Parameters:
    - database (string):
        The database name (e.g., target.database).
    - required_tables (list[string]):
        Physical relation names to check for presence within each schema.
        The match is on UPPER(table_name).

  Returns:
    - list[string] of schema names.

  Typical usage:
    {% set db = target.database %}
    {% set req = ['STG_GP_TNS__PM30200','STG_GP_TNS__PM00200','STG_GP_TNS__MC40000'] %}
    {% set schemas = get_valid_schemas_list(db, req) %}
    -- schemas now holds every schema in <db> that has ALL three tables.

  Notes / Caveats:
    - This checks INFORMATION_SCHEMA.TABLES only (i.e., base tables).
      If your objects are VIEWS (common for dbt views), they will not appear here.
      In that case, either:
        • materialize those models as TABLE, or
        • adapt this macro to query INFORMATION_SCHEMA.VIEWS (or UNION both).
    - Requires permission to read <database>.INFORMATION_SCHEMA.TABLES.
    - Case-insensitive by using UPPER(table_name) = UPPER('<name>').
    - Performance scales with number of schemas/tables in the database;
      the EXISTS pattern is usually efficient.

----------------------------------------------------------------------------- #}
{% macro get_valid_schemas_list(database, required_tables) %}
  {# Build EXISTS(...) clauses that correlate on table_schema #}
  {% set exists_clauses = [] %}
  {% for tbl in required_tables %}
    {% do exists_clauses.append(
      "EXISTS (SELECT 1
               FROM " ~ database ~ ".information_schema.tables x
               WHERE x.table_catalog = '" ~ database ~ "'
                 AND x.table_schema = t1.table_schema
                 AND upper(x.table_name) = upper('" ~ tbl ~ "'))"
    ) %}
  {% endfor %}

  {% set sql %}
    select t1.table_schema
    from {{ database }}.information_schema.tables t1
    where t1.table_catalog = '{{ database }}'
      and {{ exists_clauses | join("\n      and ") }}
    group by t1.table_schema
  {% endset %}

  {% if execute %}
    {% set res = run_query(sql) %}
    {% set schemas = res.columns[0].values() %}
  {% else %}
    {% set schemas = [] %}
  {% endif %}

  {{ return(schemas) }}
{% endmacro %}
