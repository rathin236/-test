with source as (

    select * from {{ source('slade_sap', 'glt0') }}

),

renamed as (

    select

        rpmax,
        tsl07,
        ksl09,
        tsl14,
        tslvt,
        hsl02,
        tsl10,
        ksl12,
        ksl05,
        tsl03,
        ksl01,
        hsl09,
        hsl16,
        rrcty,
        hsl05,
        bukrs,
        ksl15,
        hsl12,
        ksl08,
        tsl13,
        tsl06,
        rvers,
        hsl01,
        ksl11,
        tsl02,
        ksl04,
        cspred,
        hsl08,
        hsl15,
        tsl09,
        tsl16,
        hsl04,
        racct,
        hsl11,
        ksl14,
        tsl05,
        kslvt,
        ksl07,
        tsl12,
        rtcur,
        drcrk,
        ksl10,
        rclnt,
        tsl01,
        ksl03,
        hsl07,
        hsl14,
        hslvt,
        tsl08,
        tsl15,
        hsl03,
        hsl10,
        ksl13,
        tsl11,
        ksl06,
        tsl04,
        ksl02,
        rldnr,
        ryear,
        hsl06,
        hsl13,
        rbusa,
        ksl16,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
