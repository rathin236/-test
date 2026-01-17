{% macro aging_originating_buckets(duedate_col, docdate_col, curtrxam_col) %}
    case
        when datediff(day, {{ duedate_col }}, current_date()) < 1 then {{ curtrxam_col }}
        else 0
    end as current_org_amt_due_dt,
    case
        when datediff(day, {{ duedate_col }}, current_date()) between 1 and 15 then {{ curtrxam_col }}
        else 0
    end as "1_to_15_days_org_amt_due_dt",
    case
        when datediff(day, {{ duedate_col }}, current_date()) between 16 and 30 then {{ curtrxam_col }}
        else 0
    end as "16_to_30_days_org_amt_due_dt",
    case
        when datediff(day, {{ duedate_col }}, current_date()) between 31 and 60 then {{ curtrxam_col }}
        else 0
    end as "31_to_60_days_org_amt_due_dt",
    case
        when datediff(day, {{ duedate_col }}, current_date()) between 61 and 90 then {{ curtrxam_col }}
        else 0
    end as "61_to_90_days_org_amt_due_dt",
    case
        when datediff(day, {{ duedate_col }}, current_date()) > 90 then {{ curtrxam_col }}
        else 0
    end as "91_and_over_org_amt_due_dt",
        case
        when datediff(day, {{ docdate_col }}, current_date()) < 1 then {{ curtrxam_col }}
        else 0
    end as current_org_amt_doc_dt,
    case
        when datediff(day, {{ docdate_col }}, current_date()) between 1 and 15 then {{ curtrxam_col }}
        else 0
    end as "1_to_15_days_org_amt_doc_dt",
    case
        when datediff(day, {{ docdate_col }}, current_date()) between 16 and 30 then {{ curtrxam_col }}
        else 0
    end as "16_to_30_days_org_amt_doc_dt",
    case
        when datediff(day, {{ docdate_col }}, current_date()) between 31 and 60 then {{ curtrxam_col }}
        else 0
    end as "31_to_60_days_org_amt_doc_dt",
    case
        when datediff(day, {{ docdate_col }}, current_date()) between 61 and 90 then {{ curtrxam_col }}
        else 0
    end as "61_to_90_days_org_amt_doc_dt",
    case
        when datediff(day, {{ docdate_col }}, current_date()) > 90 then {{ curtrxam_col }}
        else 0
    end as "91_and_over_org_amt_doc_dt"
{% endmacro %}
