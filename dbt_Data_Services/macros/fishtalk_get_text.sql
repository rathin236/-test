{% macro fishtalk_get_text(textid, text, lang) %}
  {% if textid | int > 0 %}

    {% set text_query %}
      select text from {{ ref('stg_fishtalk__public_translations') }}
      where textid = {{ textid }} and languageid = {{ lang }}
      limit 1
    {% endset %}

    {% set text_result = run_query(text_query) %}
    {% set text = text_result[0]['text'] if text_result %}

  {% elif textid != -3 %}
    {% set text = text %}
  {% else %}

    {% set parsed_xml = parse_xml(text) %}
    {% set text = coalesce(
                    parsed_xml.value('(xml/txt[@lid={{ lang }}])[1]', 'string'),
                    parsed_xml.value('(xml/txt[@lid="-1"])[1]', 'string'),
                    parsed_xml.value('(xml/txt)[1]', 'string')
                 ) %}

    {% if text is null %}
      {% set text = 'Invalid xml or no text in xml' %}
    {% endif %}

  {% endif %}
  {{ text }}
{% endmacro %}
