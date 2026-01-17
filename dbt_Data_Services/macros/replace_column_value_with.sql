{% macro replace_column_value_with(column_name, replacements, replacement_value) %}
    {% set result = column_name %}
    {% for old in replacements %}
        {% set result = "replace(" ~ result ~ ", '" ~ old ~ "', '" ~ replacement_value ~ "')" %}
    {% endfor %}
    {{ result }}
{% endmacro %}
