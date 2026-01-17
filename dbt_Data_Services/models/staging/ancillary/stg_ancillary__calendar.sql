with source as (

    select * from {{ source('ancillary', 'Calendar') }}

),

renamed as (

    select
        "Key_Date",
        "Number_FiscalWeek",
        "Number_FiscalQuarter",
        "Number_FiscalYear",
        "Name_DayOfWeekEnglish",
        "Name_DayOfWeekSpanish",
        "Name_MonthSpanish",
        "Number_DayOfWeek",
        "Number_CalendarWeek"

    from source

)

select * from renamed
