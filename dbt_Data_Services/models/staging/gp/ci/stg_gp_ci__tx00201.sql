with source as (

    select * from {{ source('ci_dbo', 'tx00201') }}

),

renamed as (

    select
        taxdtlid,
        txdtldsc,
        tdtabpct,
        txdtlpdc,
        txdtlamt,
        tdtaxtax,
        dex_row_id,
        taxposttoacct,
        address3,
        address1,
        txdtlbse,
        address2,
        country,
        tdtlrndg,
        cmnytxid,
        txdxdisc,
        noteindx,
        taxboxes,
        fax,
        cntcprsn,
        tdrngtyp,
        taxinvreqd,
        txdbodtl,
        txdtqual,
        tdtaxmax,
        tdtabmax,
        txdtltyp,
        name,
        actindx,
        txusrdf2,
        txusrdf1,
        ignrgrssamnt,
        phone3,
        state,
        phone2,
        phone1,
        txidnmbr,
        txdtlpch,
        vatregtx,
        txdtlpct,
        tdtaxmin,
        tdtabmin,
        zipcode,
        city,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
