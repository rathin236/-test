with source as (

    select * from {{ source('coolearth', 'wmproductionlinedef') }}

),

renamed as (

    select
        warehouse,
        company,
        dbserverdatetime,
        _fivetran_deleted,
        _fivetran_synced,
        autopalletizerlabelfilename,
        autopalletizerlabelcopies,
        autopalletizerlineprinter,
        trim(linekey) as linekey,
        trim(linedescription) as linedescription,
        trim(wmproductionlinedef_id) as wmproductionlinedef_id

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
