-- Please note that this macro doesn't work, I saved this code because I thought it might be useful someday.
-- MP 2023-06-26

{% macro sscc_calc_check_sum(sscc_digits) %}

    with recursive digits as (
        select

            substring('00067670000000107', seq, 1)::number as digit,
            seq + 1 as next_seq

        from (select 1 as seq) as t

        union all

        select

            substring('00067670000000107', next_seq, 1)::number as digit,
            next_seq + 1 as next_seq

        from digits

        where next_seq <= len('00067670000000107')
    ),

    weighted_digits as (
    select
            digit,
            case 
                when mod(next_seq, 2) = 0 then digit * 3 
                else digit 
            end as weighted_digit
        from digits
    ),

    sum_weighted_digits as (
    select sum(weighted_digit) as total_weighted_digits
    from weighted_digits
    )

    select
    (10 - (total_weighted_digits % 10)) % 10 as check_digit
    from sum_weighted_digits;
{%- endmacro %}