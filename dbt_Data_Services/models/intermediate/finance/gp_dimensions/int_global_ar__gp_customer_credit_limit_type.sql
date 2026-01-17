select
    credit_limit_type,
    'GP' as source,
    upper(credit_limit_desc) as credit_limit_desc,
    md5(concat(credit_limit_type, 'GP')) as sk_credit_limit_type_global
from {{ ref('gp_customer_credit_limit_type') }}
