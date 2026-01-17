-- macros/generate_stg_from_source.sql
{% macro generate_stg_from_source(source_name, prefix='stg_', folder='models/staging', package_name=project_name) %}

{# collect all sources with this name, optionally scoped to a package #}
{% set src_nodes = [] %}
{% for s in graph.sources.values() 
       if s.source_name == source_name and s.package_name == package_name %}
  {% do src_nodes.append(s) %}
{% endfor %}

{% if src_nodes | length == 0 %}
  {{ exceptions.raise_compiler_error("No tables found for source_name=" ~ source_name ~ " in package=" ~ package_name) }}
{% endif %}

{# emit one file per table with a PATH header #}
{% for s in src_nodes | sort(attribute='name') %}
-- PATH: {{ folder }}/{{ source_name }}/{{ prefix }}{{ s.name }}.sql
with source as (
  select * from {{ source(source_name, s.name) }}
)
select
  *
from source
;
{% endfor %}

{% endmacro %}
