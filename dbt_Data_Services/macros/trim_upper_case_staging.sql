{# -----------------------------------------------------------------------------
  convert_columns(source_name, table_name, columns_to_exclude=[])

  Builds a SELECT projection over all columns in {{ source(source_name, table_name) }}:
    - Text-like columns (VARCHAR/CHAR/STRING/TEXT/NVARCHAR) => UPPER(TRIM(col)) AS col
    - Everything else (NUMBER/DATE/TIMESTAMP/BOOLEAN/BINARY/VARIANT/ARRAY/OBJECT/GEOGRAPHY/…) => col (unchanged)
    - Case-insensitive exclusions via columns_to_exclude

  Usage inside a staging CTE:
    source as (
      select {{ convert_columns('nb681_dbo', 'pm10000') }}
      from {{ source('nb681_dbo', 'pm10000') }}
    ),

  Then close your model with:
    where coalesce(_fivetran_deleted, 'FALSE') = 'TRUE'
  ----------------------------------------------------------------------------- #}
{% macro convert_columns(source_name, table_name, columns_to_exclude=[]) %}
  {% set rel = source(source_name, table_name) %}
  {% set cols = adapter.get_columns_in_relation(rel) %}
  {% set excludes = (columns_to_exclude | map('lower') | list) %}

  {% set out = [] %}
  {% for c in cols %}
    {% set cname = adapter.quote(c.name) %}
    {% set dtype = (c.data_type|string) | lower %}

    {% if c.name | lower not in excludes %}
      {# treat as text only if clearly stringy #}
      {% if 'char' in dtype or 'varchar' in dtype or 'string' in dtype or 'text' in dtype or 'nchar' in dtype or 'nvarchar' in dtype %}
        {% do out.append("upper(trim(" ~ cname ~ ")) as " ~ cname) %}
      {% else %}
        {# non-text types (number/float/boolean/date/time/timestamp/binary/variant/etc.) pass through unchanged #}
        {% do out.append(cname) %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {{ out | join(',\n        ') }}
{% endmacro %}
