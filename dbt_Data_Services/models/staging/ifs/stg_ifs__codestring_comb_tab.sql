with source as (

    select * from {{ source('ifs_prod_omeg1app', 'codestring_comb_tab') }}

),

renamed as (

    select
        posting_combination_id,
        codestring,
        rowkey,
        account,
        code_j,
        rowversion,
        code_g,
        code_f,
        code_i,
        code_h,
        code_c,
        code_b,
        code_e,
        code_d,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
