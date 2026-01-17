{# =============================================================================
  staging_utils.sql

  Graph-only helpers to:
    • Scan your project for staging models under a folder (no warehouse calls)
    • Parse GP-style staging names: stg_gp_<schema>__<TABLE>
    • Produce lists of schemas that define one or many required tables
    • Render a Python list of schemas as a tiny SQL table (VALUES)

  Notes
  - These functions use dbt's in-memory graph (manifest) and do NOT hit the DB.
  - Folder matching is by file path substring: "models/<folder>/".
  - Naming convention assumed: stg_gp_<schema>__<TABLE> (TABLE part is UPPER).
  - Safe for CI/partial-parse: guards handle missing/limited graph info.

  Quick examples
  ------------------------------------------------------------------------------
  {% set folder = 'staging/gp' %}
  {% set schemas = schemas_with_all_tables_from_folder(['PM30200','PM00200','MC40000'], folder=folder) %}

  -- Drive a UNION ALL across discovered schemas:
  with unioned as (
    {% for s in schemas %}
      select * from ( {{ render_gp_paid_ap_for(s) }} )
      {% if not loop.last %} union all {% endif %}
    {% endfor %}
  )
  select * from unioned;

  -- Or debug the discovery:
  {% do log('schemas: ' ~ (schemas | join(',')), info=True) %}

  -- If you want to materialize the discovered schemas as a SQL rowset:
  {{ render_schema_list_as_table(schemas, 'company_id') }}
============================================================================= #}

{# ---------- Helpers: normalize paths & safe graph access ---------- #}

{# Normalize a path to forward slashes; guard non-strings #}
{% macro _normpath(p) %}
  {% if p is string %}
    {{ return(p.replace('\\', '/')) }}
  {% else %}
    {{ return('') }}
  {% endif %}
{% endmacro %}

{# Safely obtain the node map from `graph` in any environment (CI, partial parse) #}
{% macro _safe_graph_nodes() %}
  {% if graph is not defined or graph is none %}
    {{ return({}) }}
  {% endif %}

  {# Try mapping-style first #}
  {% set node_map = graph.get('nodes') if graph.get is defined else none %}

  {# If missing/empty, try attribute access #}
  {% if node_map is none or (node_map | length) == 0 %}
    {% if graph.nodes is defined %}
      {% set node_map = graph.nodes %}
    {% else %}
      {% set node_map = {} %}
    {% endif %}
  {% endif %}

  {{ return(node_map or {}) }}
{% endmacro %}

{# ---------- Scan folder for staging models ---------- #}

{# Return all dbt model nodes whose file path contains "models/<folder>/".
   Safe in CI/partial-parse: returns [] if graph/nodes are unavailable. #}
{% macro list_staging_nodes(folder='staging/gp', debug=false) %}
  {% set node_map = _safe_graph_nodes() %}
  {% if node_map is none or (node_map | length) == 0 %}
    {% do log("[list_staging_nodes] graph has no 'nodes'; returning [].", info=True) %}
    {{ return([]) }}
  {% endif %}

  {% set want = (_normpath('models/' ~ folder ~ '/')).lower() %}
  {% set nodes = [] %}

  {% for n in node_map.values() if n.resource_type == 'model' %}
    {% set p1 = _normpath(n.original_file_path if n.original_file_path is defined else '') | lower %}
    {% set p2 = _normpath(n.path if n.path is defined else '') | lower %}
    {% if want in p1 or want in p2 %}
      {% do nodes.append(n) %}
    {% endif %}
  {% endfor %}

  {% if debug %}
    {% do log('[list_staging_nodes] want=' ~ want ~ ' count=' ~ (nodes|length), info=True) %}
    {% for n in nodes %}
      {% set shown = n.original_file_path if n.original_file_path is defined else (n.path if n.path is defined else '') %}
      {% do log('  ' ~ n.name ~ '  (' ~ _normpath(shown) ~ ')', info=True) %}
    {% endfor %}
  {% endif %}

  {{ return(nodes) }}
{% endmacro %}

{# ---------- Parse names like: stg_gp_<schema>__<table> ---------- #}

{# Parse GP-style staging model names into (schema, table).
   Returns {'schema': <lower>, 'table': <UPPER>} or {'schema': None, 'table': None}. #}
{% macro parse_gp_stg_name(model_name) %}
  {% set parts = model_name.split('__') %}
  {% if parts | length >= 2 and parts[0].startswith('stg_gp_') %}
    {% set left   = parts[0] %}        {# e.g., 'stg_gp_cai' #}
    {% set table  = parts[1] | upper %}
    {% set schema = left[7:]  | lower %}
    {{ return({'schema': schema, 'table': table}) }}
  {% else %}
    {{ return({'schema': None, 'table': None}) }}
  {% endif %}
{% endmacro %}

{# ---------- Build schema lists from filenames (no DB touch) ---------- #}

{# List of schemas (company codes) that have a staging model named
   stg_gp_<schema>__<table_code> under models/<folder>/. #}
{% macro schemas_with_table_from_folder(table_code, folder='staging/gp') %}
  {% set want = table_code | upper %}
  {% set nodes = list_staging_nodes(folder) %}
  {% set schemas = [] %}

  {% for n in nodes %}
    {% set p = parse_gp_stg_name(n.name) %}
    {% if p.schema and p.table and p.table == want %}
      {% if p.schema not in schemas %}
        {% do schemas.append(p.schema) %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {{ return(schemas) }}
{% endmacro %}

{# Return schemas that define ALL required table codes as staging models
   under models/<folder>/ following stg_gp_<schema>__<TABLE>. #}
{% macro schemas_with_all_tables_from_folder(required_tables, folder='staging/gp') %}
  {% set node_map = _safe_graph_nodes() %}
  {% if node_map is none or (node_map | length) == 0 %}
    {% do log("schemas_with_all_tables_from_folder: graph has no 'nodes'; returning [].", info=True) %}
    {{ return([]) }}
  {% endif %}

  {% set need = required_tables | map('upper') | list %}
  {% set nodes = list_staging_nodes(folder) %}
  {% set by_schema = {} %}

  {% for n in nodes %}
    {% set p = parse_gp_stg_name(n.name) %}
    {% if p.schema and p.table %}
      {% if p.schema not in by_schema %}
        {% do by_schema.update({p.schema: []}) %}
      {% endif %}
      {% set cur = by_schema[p.schema] %}
      {% if p.table not in cur %}
        {% do cur.append(p.table) %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {% set winners = [] %}
  {% for s, tables in by_schema.items() %}
    {% set ns = namespace(all_ok=true) %}
    {% for t in need %}
      {% if t not in tables %}
        {% set ns.all_ok = false %}
      {% endif %}
    {% endfor %}
    {% if ns.all_ok %}
      {% do winners.append(s) %}
    {% endif %}
  {% endfor %}

  {{ return(winners) }}
{% endmacro %}

{# ---------- Render a list of schemas as a tiny SQL table (SAFE) ---------- #}

{# Turn a Python list of schema codes into a SQL rowset via VALUES. #}
{% macro render_schema_list_as_table(schemas, column_name='schema') %}
  {% set n = schemas | length %}
  {% if n == 0 %}
select column1 as {{ column_name }}
from values (null)
where 1=2
  {% else %}
select column1 as {{ column_name }}
from values
{% for s in schemas %}
  ('{{ s | upper }}'){% if not loop.last %},{% endif %}
{% endfor %}
  {% endif %}
{% endmacro %}

{# ---------- Optional: register folder refs to help dependency inference ---------- #}

{# Force dbt to register refs to staging parents in a folder, filtered by table codes.
   Example at top of an INT model that unions by schema:
     -- depends_on: {{ ref('stg_gp__company_name') }}
     {% do _register_gp_parents('staging/gp', ['PM30200','PM00200','MC40000']) %}
 #}
{% macro _register_gp_parents(folder, tables) %}
  {% set node_map = _safe_graph_nodes() %}
  {% if node_map is none or (node_map | length) == 0 %}
    {{ return(none) }}
  {% endif %}

  {% set want = (_normpath('models/' ~ folder ~ '/')).lower() %}
  {% set need = tables | map('upper') | list %}

  {% for n in node_map.values()
       if n.resource_type == 'model'
       and n.package_name == project_name %}
    {% set p1 = _normpath(n.original_file_path if n.original_file_path is defined else '') | lower %}
    {% set p2 = _normpath(n.path if n.path is defined else '') | lower %}
    {% if want in p1 or want in p2 %}
      {% set parsed = parse_gp_stg_name(n.name) %}
      {% if parsed.schema and parsed.table and (parsed.table in need) %}
        {% do ref(n.name) %}
      {% endif %}
    {% endif %}
  {% endfor %}
  {{ return(none) }}
{% endmacro %}

-- macros/emit_gp_depends_on.sql
{% macro declare_depends_from_graph(prefix='stg_gp_', suffixes=[], fallback_models=[]) -%}
{# Safely get nodes from graph; graph may be missing during initial parse #}
{%- set _g = graph if graph is mapping else {} -%}
{%- set _nodes = _g.get('nodes', {}) -%}
{%- set _emitted = [] -%}

{%- for node in _nodes.values() %}
  {%- if node.resource_type == 'model'
        and node.config.enabled
        and node.name.startswith(prefix) -%}
    {%- for sfx in suffixes %}
      {%- if node.name.endswith(sfx) -%}
-- depends_on: {{ ref(node.name) }}
{%- do _emitted.append(node.name) -%}
      {%- endif -%}
    {%- endfor -%}
  {%- endif -%}
{%- endfor -%}

{# If nothing was emitted (graph empty / no matches), fall back to a minimal set #}
{%- if _emitted | length == 0 -%}
  {%- for m in fallback_models %}
-- depends_on: {{ ref(m) }}
  {%- endfor -%}
{%- endif -%}
{%- endmacro %}


