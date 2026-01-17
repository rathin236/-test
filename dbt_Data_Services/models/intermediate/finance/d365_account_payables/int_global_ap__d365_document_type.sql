select
        enumvalue as doctype,
        'D365' as source,
        upper(enumvaluelabel) as document_type,
         md5(concat(doctype, 'D365')) as sk_doctype_global
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 2715
