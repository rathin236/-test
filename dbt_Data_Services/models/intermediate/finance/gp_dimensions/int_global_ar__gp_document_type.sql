select
    doctype,
    'GP' as source,
    upper(document_type) as document_type,
    md5(concat(doctype, 'GP')) as sk_doctype_global
from {{ ref('ar_gp__document_types') }}
