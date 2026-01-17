{% macro standard_unit(unit_of_measure) %}
    case
        when trim({{ unit_of_measure }}) in ('ea', 'EACH', 'EA', 'Each', 'each') then 'EACH'
        when trim({{ unit_of_measure }}) in ('cs', 'CASE', 'Case', 'CS', 'case') then 'CASE'
        when trim({{ unit_of_measure }}) in ('LB', 'lb', 'Lb', 'lB') then 'LB'
        when trim({{ unit_of_measure }}) in ('KG', 'kg', 'Kg', 'kG') then 'KG'
        when trim({{ unit_of_measure }}) in ('BAG', 'bag', 'Bag', 'Bg', 'BG') then 'BAG'
        when trim({{ unit_of_measure }}) in ('Tub', 'TUB', 'TB', 'tb', 'tub') then 'TUB'
        else {{ unit_of_measure }}
    end
{% endmacro %}
