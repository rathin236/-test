with

source as (

    select * from {{ source('metaviewer_dbo', 'userprofile') }}

),

renamed as (

    select
        userprofileid,
        providerid,
        loginname,
        providerlogin1,
        datarev,
        isenabled,
        providerlogin2,
        managecredentials,
        scopeid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
