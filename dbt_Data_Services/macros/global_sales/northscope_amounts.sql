{% macro northscope_amounts(currency_id, amount, fx_rate1, fx_rate2, returned_order) -%}
        case
            when {{ returned_order }} = 4
                then
                    case
                        when {{ currency_id }} not in ('CAD', 'USD')
                            then -{{ amount }} * {{ fx_rate2 }}
                        when {{ currency_id }} = 'CAD'
                            then -{{ amount }} * coalesce({{ fx_rate1}}, {{ fx_rate2 }})
                        when {{ currency_id }} = 'USD'
                            then -{{ amount }}
                        else -{{ amount }}
                    end
            else
                case
                    when {{ currency_id }} not in ('CAD', 'USD')
                        then {{ amount }} * {{ fx_rate2 }}
                    when {{ currency_id }} = 'CAD'
                        then {{ amount }} * coalesce({{ fx_rate1}}, {{ fx_rate2 }})
                    when {{ currency_id }} = 'USD'
                        then {{ amount }}
                    else {{ amount }}
                end
        end
{%- endmacro %}