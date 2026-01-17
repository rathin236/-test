with

source as (

    select {{ convert_columns('finops_synapse', 'dlvterm') }}
    from {{ source('finops_synapse', 'dlvterm') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        custominventtransstatus_ru,
        misccharges_it,
        shipcarrierapplyfreeminimum,
        shipcarrierfreightapplied,
        taxlocationrole,
        freightchargeterm,
        itmportmandatory,
        itmgoodsintransitcontrol,
        sysdatastatecode,
        code,
        custominventprofileid_ru,
        intrastatcode,
        shipcarrierfreeminimum,
        txt,
        modifieddatetime,
        modifiedby,
        modifiedtransactionid,
        createddatetime,
        createdby,
        createdtransactionid,
        dataareaid,
        recversion,
        partition,
        sysrowversion,
        recid,
        tableid,
        versionnumber,
        createdon,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
