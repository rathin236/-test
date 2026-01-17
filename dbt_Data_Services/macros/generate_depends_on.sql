{%- macro generate_depends_on(my_list)-%}
{% for model in my_list -%}
{% set depends_on = "--depends_on: {{  ref( '" ~  model ~ "' )  }}" %}
{{  depends_on  }}
{%- endfor %}
{%- endmacro-%}