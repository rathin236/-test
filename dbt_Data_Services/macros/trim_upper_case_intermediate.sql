{# -----------------------------------------------------------------------------
  trim_columns_int(table_name, columns_to_exclude=[])

  Purpose:
    Build a SELECT projection for a *model* referenced via ref(table_name):
      - Text-like columns (VARCHAR/CHAR/STRING/TEXT/NVARCHAR) → UPPER(TRIM(col)) AS col
      - Non-text columns (NUMBER/DATE/TIMESTAMP/BOOLEAN/BINARY/VARIANT/…) → pass-through AS col
      - Case-insensitive exclusions via columns_to_exclude (those columns pass through)

  Notes:
    - When dbt is compiling without executing (e.g., docs/parse), this returns "*" to avoid
      warehouse introspection at compile time.
    - BINARY/VARBINARY are never trimmed (avoids TRIM(BINARY) errors).

  Typical usage in a staging CTE (for a built/ref’able model):
    with paid_invoices as (
      select {{ trim_columns_int('stg_gp_nb681__pm10000') }}
      from {{ ref('stg_gp_nb681__pm10000') }}
    ),
----------------------------------------------------------------------------- #}
{% macro trim_columns_int(table_name, columns_to_exclude=[]) -%}
  {# When not executing (e.g., pure compile), don't introspect columns #}
  {% if not execute %}
    {{ return("*") }}
  {% endif %}

  {# Resolve relation and fetch columns #}
  {% set relation = ref(table_name) %}
  {% set cols = adapter.get_columns_in_relation(relation) %}

  {# Build a case-insensitive exclude set #}
  {% set exclude_upper = columns_to_exclude | map('upper') | list %}

  {# Build projection with safe trimming only for text-like types #}
  {% set projected = [] %}
  {% for col in cols %}
    {% set name_quoted = adapter.quote(col.name) %}
    {% set dtype = (col.data_type or '') | upper %}

    {% set is_text =
         ('CHAR' in dtype) or
         ('STRING' in dtype) or
         ('TEXT' in dtype) or
         ('VARCHAR' in dtype) or
         ('NVARCHAR' in dtype)
    %}

    {% if (col.name | upper) in exclude_upper or (not is_text) or ('BINARY' in dtype) %}
      {% set expr = name_quoted ~ " AS " ~ name_quoted %}
    {% else %}
      {% set expr = "UPPER(TRIM(" ~ name_quoted ~ ")) AS " ~ name_quoted %}
    {% endif %}

    {% do projected.append(expr) %}
  {% endfor %}

  {{ projected | join(', ') }}
{%- endmacro %}
